{
  description = "OpenTofu setup for my DNS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/26.05";
  };
  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          (opentofu.withPlugins (
            plugin: with plugin; [
              pan-net_powerdns
            ]
          ))
        ];
      };
    };
}
