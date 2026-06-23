default:
    @just --list

check *files=".":
    statix check {{files}}  

format:
    nix fmt **/*.nix

build host:
    nixos-rebuild build --log-format internal-json --flake .#{{host}} |& nom --json

update date-arg="":
    #!/usr/bin/env bash
    if [ -n "{{date-arg}}" ]; then
        sha=$(curl -sf "https://api.github.com/repos/NixOS/nixpkgs/commits?sha=nixpkgs-unstable&until==$(date -d '{{date-arg}}' +%Y-%m-%dT00:00:00Z)&per_page=1" | jq -r '.[0].sha')
        echo "Pinning nixpkgs to $sha (latest before {{date-arg}})"
        nix flake lock --override-input unstablenixpkgs github:NixOS/nixpkgs/"$sha"
    else
        nix flake update
    fi

build-livecd:
    nix build --log-format internal-json .#nixosConfigurations.livecd.config.system.build.isoImage |& nom --json

clean:
    rm -rf result *qcow2

check-flake:
    nix flake check
