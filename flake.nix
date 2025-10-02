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
        ./configuration.nix
      ];
    };
    
    devShells.${arch}.default = pkgs.mkShell {
      packages = with pkgs; [ nil nixpkgs-fmt ];
    };
    formatter.${arch} = pkgs.nixpkgs-fmt;
  };
}

