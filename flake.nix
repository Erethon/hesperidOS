{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "https://channels.nixos.org/nixos-26.05/nixexprs.tar.zst";
    unstablenixpkgs.url = "https://channels.nixos.org/nixos-unstable/nixexprs.tar.zst";
    impermanence.url = "github:nix-community/impermanence";
    microvm = {
      url = "github:microvm-nix/microvm.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix = {
      url = "github:ryantm/agenix";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
  };

  outputs =
    {
      self,
      agenix,
      disko,
      microvm,
      nixpkgs,
      unstablenixpkgs,
      ...
    }@inputs:
    let
      pkgs = unstablenixpkgs.legacyPackages.x86_64-linux;
      mkHost =
        {
          channel ? unstablenixpkgs,
          modules,
        }:
        channel.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [ ./default.nix ] ++ modules;
        };
    in
    {
      formatter.x86_64-linux = pkgs.nixfmt;
      devShells.x86_64-linux.default = pkgs.mkShell {
        buildInputs = with pkgs; [
          just
          statix
          pre-commit
          (opentofu.withPlugins (
            plugin: with plugin; [
              pan-net_powerdns
            ]
          ))
        ];
      };
      dnsRecords =
        let
          lib = nixpkgs.lib;

          mergeField = {
            ttl = lib.foldl' lib.min 86400;
            values = vs: lib.unique (lib.concatLists vs);
          };
        in
        lib.pipe self.nixosConfigurations [
          lib.attrValues
          (map (host: host.config.erethon.dns.records or { }))
          (lib.zipAttrsWith (_name: lib.zipAttrsWith (_type: lib.zipAttrsWith (field: mergeField.${field}))))
        ];

      nixosConfigurations = {
        okeanos1 = mkHost {
          modules = [
            disko.nixosModules.disko
            ./hosts/okeanos1/default.nix
            ./modules/common/default.nix
          ];
        };
        darky = mkHost {
          channel = nixpkgs;
          modules = [
            disko.nixosModules.disko
            microvm.nixosModules.host
            ./modules/bgp/default.nix
            ./modules/common/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/initrdssh/default.nix
            ./hosts/darky/default.nix
          ];
        };
        sobeck = mkHost {
          modules = [
            disko.nixosModules.disko
            microvm.nixosModules.host
            ./hosts/sobeck/default.nix
            ./modules/bgp/default.nix
            ./modules/common/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/initrdssh/default.nix
            ./modules/unbound/default.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        };
        orinoco = mkHost {
          modules = [
            ./hosts/orinoco
            ./modules/workstation
          ];
        };
        niato = mkHost {
          modules = [
            ./hosts/niato
            ./modules/workstation
          ];
        };
        livecd = mkHost {
          modules = [
            "${nixpkgs}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
            ./modules/desktop/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/unbound/default.nix
            { nixpkgs.hostPlatform = "x86_64-linux"; }
          ];
        };
        rpi4rf = mkHost {
          modules = [
            "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-installer.nix"
            ./hosts/rpi4rf/default.nix
            ./modules/sdr/default.nix
            {
              sdImage.compressImage = false;
              nixpkgs.hostPlatform = "aarch64-linux";
            }
          ];
        };
        nixosvpn = mkHost {
          modules = [
            ./hosts/nixosvpn/default.nix
          ];
        };
        connector = mkHost {
          modules = [
            ./hosts/connector/default.nix
            ./modules/unbound/default.nix
          ];
        };
        warden = mkHost {
          modules = [
            ./modules/persistence/default.nix
            ./hosts/warden/default.nix
            agenix.nixosModules.default
          ];
        };
      };
    };
}
