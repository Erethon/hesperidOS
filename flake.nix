{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
    impermanence.url = "github:nix-community/impermanence";
  };

  outputs = { self, nixpkgs, impermanence, ...}@inptus: {
    formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
    nixosConfigurations.niato = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./default.nix
        ./hosts/niato/configuration.nix
        impermanence.nixosModules.impermanence
      ];
    };
  };
}
