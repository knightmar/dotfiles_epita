#!/usr/bin/env bash

# --- CONFIG ---
STEP=5
VCP_CODE="10"
DELAY=0.1
CACHE_DIR="/tmp/brightness_cache"
MAP_FILE="$CACHE_DIR/monitor_map"
mkdir -p "$CACHE_DIR"

# --- FUNCTION: AUTO-GENERATE MAP ---
# This links Hyprland names (DP-1) to I2C buses (8)
generate_map() {
    # We only run this 'slow' command if we don't know the monitor yet
    ddcutil detect --brief | awk '
        /I2C bus:/ { bus=$NF; sub(/.*i2c-/, "", bus) }
        /DRM connector:/ { 
            conn=$NF; 
            sub(/card[0-9]-/, "", conn); 
            if (bus && conn) print conn ":" bus 
        }
    ' > "$MAP_FILE"
}

# 1. Get focused monitor name from Hyprland (Fast: ~5ms)
MON_NAME=$(hyprctl monitors -j | jq -r '.[] | select(.focused == true) | .name')

# 2. Check if we know this monitor. If not, map it!
if ! grep -q "^$MON_NAME:" "$MAP_FILE" 2>/dev/null; then
    generate_map
fi

BUS=$(grep "^$MON_NAME:" "$MAP_FILE" | cut -d':' -f2)

# Fallback for Laptop (no I2C bus)
if [[ -z "$BUS" ]]; then
    if brightnessctl l | grep -q "backlight"; then
        MODE="laptop"
    else
        # If still nothing, exit to prevent errors
        exit 1
    fi
else
    MODE="desktop"
fi

STATE_FILE="$CACHE_DIR/bus_$BUS"

# 3. Get Current Value (Immediate from cache)
if [[ -f "$STATE_FILE" ]]; then
    current=$(cat "$STATE_FILE")
else
    if [[ "$MODE" == "laptop" ]]; then
        current=$(brightnessctl -m | grep -o '[0-9]\+%' | head -c-2)
    else
        current=$(ddcutil getvcp $VCP_CODE --bus "$BUS" --brief | awk '{print $4}' | tr -d ',')
    fi
    echo "$current" > "$STATE_FILE"
fi

# 4. Handle Actions
case $1 in
    i) new=$(( current + STEP )); [[ $new -gt 100 ]] && new=100 ;;
    d) new=$(( current - STEP )); [[ $new -lt 0 ]] && new=0 ;;
    *) new=$current ;;
esac

# 5. UI UPDATE: Output to Waybar IMMEDIATELY
if ((new <= 20)); then icon="󰃞 "; elif ((new <= 60)); then icon="󰃝 "; else icon="󰃠 "; fi
echo "{\"text\": \"${icon}\", \"percentage\": $new, \"tooltip\": \"Monitor: $MON_NAME\nBus: $BUS\nBrightness: $new%\"}"

# 6. HARDWARE UPDATE: Backgrounded with Pkill/Debounce
if [[ "$1" == "i" || "$1" == "d" ]]; then
    echo "$new" > "$STATE_FILE"

    # Synchronized Notification
    notify-send -h string:x-canonical-private-synchronous:brightness_"$BUS" \
                -h int:value:"$new" -u low -t 800 "Brightness: ${new}%"

    if [[ "$MODE" == "laptop" ]]; then
        brightnessctl set "$new%"
    else
        pkill -f "ddc_update_bus_$BUS"
        (
            # ddc_update_bus_$BUS (Comment for pkill to find)
            sleep "$DELAY"
            final_val=$(cat "$STATE_FILE")
            ddcutil setvcp $VCP_CODE "$final_val" --bus "$BUS" --noverify --sleep-multiplier .01 > /dev/null 2>&1
        ) &
    fi
fi
