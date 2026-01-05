#!/bin/bash

# Options du menu
options="🔒 Verrouiller\n🚪 Fermer la session\n↩️ Redémarrer\n⏻ Éteindre"

# Thème inline minimal — auto-suffisant
rofi_theme='
* {
    background: #3C3835;
    foreground: #5E5853;
    selected: #3C3835;
    border-color: #5E5853;
    border-width: 2px;
    font: "JetBrainsMono Nerd Font 12";
}

window {
    width: 20%;
    border-radius: 10px;
    background-color: @background;
    border: @border-width;
    border-color: @border-color;
}

listview {
    lines: 4;
    fixed-height: false;
}

element {
    padding: 8px;
    border-radius: 5px;
    background-color: transparent;
    text-color: @foreground;
}

element selected {
    background-color: @selected;
    text-color: @background;
}
'

# Lancer rofi avec ton thème inline, sans charger les thèmes ML4W
chosen="$(echo -e "$options" | rofi -no-config -no-lazy-grab -no-fixed-num-lines -dmenu -i -p "Action :" -theme-str "$rofi_theme" -selected-row 0 -me-select-entry '' -me-accept-entry 'MousePrimary')"
case "$chosen" in
    "🔒 Verrouiller")
        hyprlock
        ;;
    "↩️ Redémarrer")
        systemctl reboot
        ;;
    "⏻ Éteindre")
        systemctl poweroff
        ;;
    "🚪 Fermer la session")
        hyprctl dispatch exit
        ;;
    *)
        exit 0
        ;;
esac

