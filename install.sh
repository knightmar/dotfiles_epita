#!/run/current-system/sw/bin/bash
packages=""
while IFS= read -r line; do
    echo "installing $line"
    packages+="nixpkgs#$line "
done < packages.txt
#nix profile install --impure --expr 'with builtins.getFlake("flake:nixpkgs"); legacyPackages.x86_64-linux.nerdfonts.override { fonts = ["JetBrainsMono"]; }'
packages=${packages% }
echo $packages
nix profile install $packages
