{
  description = "Configuración NixOS de montoshita";

  inputs = {
    # La fuente principal de paquetes (misma versión que tu sistema)
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Home Manager, anclado a la misma versión
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs"; # usa el MISMO nixpkgs, no uno aparte
    };

    # Caelestia Shell oficial
    caelestia.url = "github:caelestia-dots/shell";
  };

  outputs = { self, nixpkgs, home-manager, ... }@inputs: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {

      specialArgs = { inherit inputs; };

      modules = [
        ./configuration.nix

        # Integrar home-manager como módulo del sistema
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;   # comparte pkgs del sistema
          home-manager.useUserPackages = true;  # instala paquetes en el perfil del usuario
          home-manager.backupFileExtension = "backup";
          home-manager.extraSpecialArgs = { inherit inputs; };
          home-manager.sharedModules = [ inputs.caelestia.homeManagerModules.default ];
          home-manager.users.montoshita = import ./home/montoshita.nix;
        }
      ];
    };
  };
}
