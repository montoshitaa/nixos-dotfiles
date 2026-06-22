{
  description = "NixOS dotfiles - montoshita";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    system = "x86_64-linux";

    mkSystem = hostPath: nixpkgs.lib.nixosSystem {
      inherit system;
      modules = [
        hostPath
        home-manager.nixosModules.home-manager
      ];
    };
  in {
    nixosConfigurations.thinkpad-l13 = mkSystem ./hosts/thinkpad-l13;

    # Agregar más hosts aquí:
    # nixosConfigurations.laptop = mkSystem ./hosts/laptop;

    templates = {
      cpp = {
        path = ./dev-templates/cpp;
        description = "C/C++ development environment";
      };
      java = {
        path = ./dev-templates/java;
        description = "Java development environment";
      };
      nodejs = {
        path = ./dev-templates/nodejs;
        description = "Node.js development environment";
      };
      python = {
        path = ./dev-templates/python;
        description = "Python development environment";
      };
      rust = {
        path = ./dev-templates/rust;
        description = "Rust development environment";
      };
    };

    formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt;
  };
}
