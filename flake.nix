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
  };

  outputs = { self, nixpkgs, home-manager, ... }: {
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux"; # Cámbialo a "aarch64-linux" si tienes ARM

      modules = [
        ./configuration.nix

        # Integrar home-manager como módulo del sistema
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;   # comparte pkgs del sistema
          home-manager.useUserPackages = true;  # instala paquetes en el perfil del usuario
          home-manager.users.montoshita = import ./home/montoshita.nix;
        }
      ];
    };
  };
}
