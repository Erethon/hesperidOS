{
  description = "Erethon's (dgrig) NixOS setup";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-26.05";
    unstablenixpkgs.url = "github:NixOS/nixpkgs/master";
    #mynixpkgs.url = "path:/home/dgrig/Code/Nix/nixpkgs";
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
        darwin.follows = "";
        home-manager.follows = "";
      };
    };
  };

  outputs =
    {
      self,
      agenix,
      disko,
      impermanence,
      microvm,
      nixpkgs,
      unstablenixpkgs,
      #mynixpkgs,
      ...
    }@inputs:
    {
      formatter.x86_64-linux = nixpkgs.legacyPackages.x86_64-linux.nixfmt;
      devShells.x86_64-linux.default = nixpkgs.legacyPackages.x86_64-linux.mkShell {
        buildInputs = with nixpkgs.legacyPackages.x86_64-linux; [
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
          perHost = lib.mapAttrsToList (
            _: host: host.config.erethon.dns.records or { }
          ) self.nixosConfigurations;
        in
        lib.zipAttrsWith (
          _name: typesPerHost:
          lib.zipAttrsWith (_type: recs: {
            ttl = lib.foldl' lib.min 86400 (map (r: r.ttl) recs);
            values = lib.unique (lib.concatMap (r: r.values) recs);
          }) typesPerHost
        ) perHost;

      nixosConfigurations = {
        okeanos1 = unstablenixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            ./default.nix
            ./hosts/okeanos1/default.nix
            ./modules/common/default.nix
          ];
        };
        darky = unstablenixpkgs.lib.nixosSystem {
          modules = [
            impermanence.nixosModules.impermanence
            disko.nixosModules.disko
            microvm.nixosModules.host
            ./default.nix
            ./modules/bgp/default.nix
            ./modules/common/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/initrdssh/default.nix
            ./hosts/darky/default.nix
          ];
        };
        vm = nixpkgs.lib.nixosSystem {
          modules = [
            ./default.nix
            ./hosts/nixosrnd/default.nix
          ];
        };
        sobeck = unstablenixpkgs.lib.nixosSystem {
          modules = [
            disko.nixosModules.disko
            impermanence.nixosModules.impermanence
            microvm.nixosModules.host
            ./default.nix
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
        orinoco = unstablenixpkgs.lib.nixosSystem {
          modules = [
            impermanence.nixosModules.impermanence
            ./default.nix
            ./hosts/orinoco/default.nix
            ./modules/common/default.nix
            ./modules/desktop/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/unbound/default.nix
          ];
        };
        niato = unstablenixpkgs.lib.nixosSystem {
          modules = [
            impermanence.nixosModules.impermanence
            microvm.nixosModules.host
            ./default.nix
            ./hosts/niato/default.nix
            ./modules/bgp/default.nix
            ./modules/common/default.nix
            ./modules/desktop/default.nix
            ./modules/persistence/default.nix
            ./modules/physical/default.nix
            ./modules/emacs/default.nix
            ./modules/firefox/default.nix
            ./modules/unbound/default.nix
          ];
        };
        nixosrnd = unstablenixpkgs.lib.nixosSystem {
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
        nixosvpn = unstablenixpkgs.lib.nixosSystem {
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
