{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    unstablenixpkgs.url = "github:NixOS/nixpkgs/master";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, impermanence, unstablenixpkgs, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    nixosConfigurations.niato = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./default.nix
        ./hosts/niato/default.nix
        ./modules/desktop/default.nix
        ./modules/persistence/default.nix
        ./modules/emacs/default.nix
        ./modules/firefox/default.nix
        ./modules/sdr/default.nix
        ./modules/unbound/default.nix
        "${unstablenixpkgs}/nixos/modules/services/networking/tailscale.nix"
        impermanence.nixosModules.impermanence
      ];
    };
    nixosConfigurations.nixosrnd = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./default.nix ./hosts/nixosrnd/default.nix ];
    };
    nixosConfigurations.livecd = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
        ./default.nix
        ./modules/desktop/default.nix
        ./modules/emacs/default.nix
        ./modules/firefox/default.nix
        ./modules/unbound/default.nix
      ];
    };
    nixosConfigurations.rpi4rf = nixpkgs.lib.nixosSystem {
      system = "aarch64-linux";
      modules = [
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
        ./default.nix
        ./hosts/rpi4rf/default.nix
        ./modules/sdr/default.nix
        { sdImage.compressImage = false; }
      ];
    };
    nixosConfigurations.nixosvpn = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./default.nix
        ./hosts/nixosvpn/default.nix
        "${unstablenixpkgs}/nixos/modules/services/networking/headscale.nix"
        {
          nixpkgs.overlays = [
            (final: prev: {
              unstable = unstablenixpkgs.legacyPackages.${prev.system};
            })
          ];
        }
      ];
    };
    nixosConfigurations.hetzner-x86_64 = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./default.nix ./hosts/hetzner/default.nix ];
    };

  };
}
