#!/bin/sh

userresources="${HOME}/.Xresources"

if [ -f "${userresources}" ]; then
    xrdb -merge "${userresources}"
fi

if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh; do
        if [ -x "${f}" ]; then
            . "${f}"
        fi
    done

    unset f
fi

xsetroot -cursor_name left_ptr
feh --bg-fill "${HOME}/.wallpaper.jpg" &

picom --config "$HOME/.config/picom.conf" &

for monitor in $(xrandr --listactivemonitors | tail -n +2 | awk '{ print $4; }'); do
    MONITOR="${monitor}" polybar -r bar &
done

dunst &
sxhkd &

exec bspwm
