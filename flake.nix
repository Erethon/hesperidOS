{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.05";
    unstablenixpkgs.url = "github:NixOS/nixpkgs/master";
    mynixpkgs.url = "path:/home/dgrig/Code/Nix/nixpkgs";
    impermanence.url = "github:nix-community/impermanence";
    disko = {
        url = "github:nix-community/disko";
        inputs.nixpkgs.follows = "nixpkgs";
    };
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
      unstablenixpkgs,
      impermanence,
      agenix,
      mynixpkgs,
      disko,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
          just
          statix
          pre-commit
        ];
      };

      nixosConfigurations = {
        vm = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./modules/common/default.nix
            ./hosts/nixosrnd/default.nix
          ];
        };
        niato = unstablenixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/niato/default.nix
            ./modules/common/default.nix
            ./modules/desktop/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/sdr/default.nix
            ./modules/unbound/default.nix
            impermanence.nixosModules.impermanence
          ];
        };
        nixosrnd = mynixpkgs.lib.nixosSystem {
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
        rpi4k3s1 = nixpkgs.lib.nixosSystem {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            ./default.nix
            ./hosts/rpi4k3s1/default.nix
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
            disko.nixosModules.disko
            ./default.nix
            ./hosts/hetzner/default.nix
            ./hosts/hetzner/disko.nix
          ];
        };
        hetznerbuilder = nixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./default.nix
            ./hosts/hetznerbuilder/default.nix
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
