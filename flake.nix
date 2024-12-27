{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.11";
    impermanence.url = "github:nix-community/impermanence";
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.darwin.follows = "";
    agenix.inputs.home-manager.follows = "";
  };

  outputs =
    {
      self,
      nixpkgs,
      impermanence,
      agenix,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt-rfc-style;
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
          impermanence.nixosModules.impermanence
        ];
      };
      nixosConfigurations.nixosrnd = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./default.nix
          ./hosts/nixosrnd/default.nix
        ];
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
        ];
      };
      nixosConfigurations.connector = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./default.nix
          ./hosts/connector/default.nix
          ./modules/unbound/default.nix
        ];
      };
      nixosConfigurations.hetzner-x86_64 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./default.nix
          ./hosts/hetzner/default.nix
        ];
      };
      nixosConfigurations.warden = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./default.nix
          ./modules/persistence/default.nix
          ./hosts/warden/default.nix
          impermanence.nixosModules.impermanence
          agenix.nixosModules.default
        ];
      };
    };
}
