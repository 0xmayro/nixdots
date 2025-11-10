{
  description = "My Nixos Configuration";

  inputs = { nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05"; };

  outputs = { self, nixpkgs, ... }:
    let
      arch = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${arch};
    in {
      formatter.${arch}.default = pkgs.nixfmt-rfc-style;
      nixosConfigurations.seraphim = nixpkgs.lib.nixosSystem {
        system = arch;
        modules = [ ./hosts/seraphim/configuration.nix ];
      };
    };
}

