{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    mynixpkgs.url = "github:erethon/nixpkgs/init-ma-module";
    impermanence.url = "github:nix-community/impermanence";
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
        darwin.follows = "";
        home-manager.follows = "";
      };
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      impermanence,
      agenix,
      mynixpkgs,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      nixosConfigurations = {
	orinoco = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/orinoco/default.nix
            ./modules/desktop/default.nix
            ./modules/persistence/default.nix
            ./modules/emacs/default.nix 
            ./modules/firefox/default.nix
            ./modules/unbound/default.nix
            impermanence.nixosModules.impermanence
          ];
        };
        niato = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/niato/default.nix
            ./modules/desktop/default.nix
            ./modules/persistence/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/sdr/default.nix
            ./modules/unbound/default.nix
            impermanence.nixosModules.impermanence
            #          "${mynixpkgs}/nixos/modules/services/web-apps/grist-core.nix" # Adjust path as needed
            # Module override configuration
            #          (
            #            { config, pkgs, ... }:
            #            {
            #              nixpkgs.overlays = [
            #                (final: prev: {
            #                  grist-core = mynixpkgs.legacyPackages.x86_64-linux.grist-core;
            #                })
            #              ];
            #            }
            #          )

          ];
        };
        nixosrnd = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/nixosrnd/default.nix
          ];
        };
        livecd = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./default.nix
            ./modules/desktop/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/unbound/default.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        };
        rpi4rf = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            ./default.nix
            ./hosts/rpi4rf/default.nix
            ./modules/sdr/default.nix
            {
              sdImage.compressImage = false;
              nixpkgs.hostPlatform = "aarch64-linux";
            }
          ];
        };
        nixosvpn = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/nixosvpn/default.nix
            "${mynixpkgs}/nixos/modules/services/matrix/matrix-alertmanager.nix" # Adjust path as needed
            # Module override configuration
            (
              { config, pkgs, ... }:
              {
                nixpkgs.overlays = [
                  (final: prev: {
                    matrix-alertmanager = mynixpkgs.legacyPackages.x86_64-linux.matrix-alertmanager;
                  })
                ];
              }
            )
          ];
        };
        connector = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/connector/default.nix
            ./modules/unbound/default.nix
          ];
        };
        hetzner-x86_64 = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/hetzner/default.nix
          ];
        };
        warden = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./modules/persistence/default.nix
            ./hosts/warden/default.nix
            impermanence.nixosModules.impermanence
            agenix.nixosModules.default
          ];
        };
      };
    };
}
