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

xrandr --output DP-1 --mode 1920x1080 --rate 75 &
xsetroot -cursor_name left_ptr

setxkbmap us,fr pc104 grp:win_space_toggle &
feh --bg-fill "${HOME}/.wallpaper.jpg" &

picom &
dunst &
sxhkd &

for monitor in $(xrandr --listactivemonitors | tail -n +2 | awk '{ print $4; }'); do
    MONITOR="${monitor}" polybar -r bar &
done

exec bspwm
