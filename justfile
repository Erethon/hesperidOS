default:
    @just --list

check *files=".":
    statix check {{files}}  

format:
    nix fmt **/*.nix

build host:
    nixos-rebuild build --flake .#{{host}}

update:
    nix flake update

build-livecd:
    nix build .#nixosConfigurations.livecd.config.system.build.isoImage

clean:
    rm -rf result *qcow2

check-flake:
    nix flake check
