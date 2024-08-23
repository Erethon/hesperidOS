{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-24.05";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, impermanence, ... }@inputs: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    nixosConfigurations.niato = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./default.nix
        ./hosts/niato/default.nix
        ./modules/desktop/default.nix
        ./modules/emacs/default.nix
        ./modules/firefox/default.nix
        ./modules/sdr/default.nix
        ./modules/unbound/default.nix
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
        ./hosts/rpi4-f/default.nix
        ./modules/sdr/default.nix
        { sdImage.compressImage = false; }
      ];
    };
  };
}
