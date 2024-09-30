# ~/.bashrc

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

if [ -d ~/afs/bin ] ; then
	export PATH=~/afs/bin:$PATH
fi

if [ -d ~/.local/bin ] ; then
	export PATH=~/.local/bin:$PATH
fi

export LANG=en_US.utf8
export NNTPSERVER="news.epita.fr"

export EDITOR=vim
#export EDITOR=emacs

# Color support for less
#export LESS_TERMCAP_mb=$'\E[01;31m'       # begin blinking
#export LESS_TERMCAP_md=$'\E[01;38;5;74m'  # begin bold
#export LESS_TERMCAP_me=$'\E[0m'           # end mode
#export LESS_TERMCAP_se=$'\E[0m'           # end standout-mode
#export LESS_TERMCAP_so=$'\E[38;5;246m'    # begin standout-mode - info box
#export LESS_TERMCAP_ue=$'\E[0m'           # end underline
#export LESS_TERMCAP_us=$'\E[04;38;5;146m' # begin underline

alias ls='ls --color=auto'
alias grep='grep --color -n'
PS1='[\u@\h \W]\$ '

alias startx='startx -- -config "$(find /nix/store -maxdepth 1 -name '*-xserver.conf' -print -quit)" -xkbdir "$(find /nix/store -maxdepth 1 -name '*-xkeyboard-config-*' -print -quit)"/etc/X11/xkb'

if [[ "$(head -c -1 "/proc/${PPID}/cmdline")" != -bash ]]; then
	return
fi

packages=( \
	nixpkgs#bspwm \
	nixpkgs#dunst \
	nixpkgs#flameshot \
	nixpkgs#font-awesome \
	nixpkgs#noto-fonts \
	nixpkgs#picom \
	nixpkgs#polybarFull \
	nixpkgs#ranger \
	nixpkgs#ripgrep \
	nixpkgs#rofi \
	nixpkgs#sxhkd \
	nixpkgs#vistafonts \
	nixpkgs#zsh \
	nixpkgs#zsh-autosuggestions \
	nixpkgs#zsh-fast-syntax-highlighting \
	nixpkgs#starship \
	nixpkgs/master#neovim \
)

set -x

nix profile install --impure "${packages[@]}"
nix profile install --impure --expr 'with builtins.getFlake("flake:nixpkgs"); legacyPackages.x86_64-linux.nerdfonts.override { fonts = ["JetBrainsMono"]; }'

if which zsh; then
	export SHELL=zsh
fi

startx
