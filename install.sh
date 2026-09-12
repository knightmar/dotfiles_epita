#!/run/current-system/sw/bin/bash

# build string from packages.txt
packages=""
while IFS= read -r line; do
    echo "installing $line"
    packages+="nixpkgs#$line "
done < packages.txt

# install custom font
nix profile install --impure --expr 'with builtins.getFlake("flake:nixpkgs"); legacyPackages.x86_64-linux.nerd-fonts.jetbrains-mono'

packages=${packages% }
echo $packages

# install the actuall packages string
nix profile install $packages

nix profile add github:NixOS/nixpkgs/nixos-unstable#hyprland
nix profile add github:ndom91/rose-pine-hyprcursor

# run Hyprland
start-hyprland
