{
  description = "My Nixos Configuration";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";
  };
  
  outputs = { self, nixpkgs, ... }: 
    let 
      arch = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${arch};
    in
  { 
    nixosConfigurations.seraphim = nixpkgs.lib.nixosSystem {
      system = arch;
      modules = [
        ./hosts/seraphim/configuration.nix
      ];
    };
    
    devShells.${arch}.default = pkgs.callPackage ./shell.nix {};
  };
}

