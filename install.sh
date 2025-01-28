while IFS= read -r line; do
    echo "installing $line"
    nix profile install "nixpkgs#$line"
done < packages.txt
