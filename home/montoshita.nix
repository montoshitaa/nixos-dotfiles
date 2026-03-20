{ config, pkgs, ... }:

# Variables (let y in)

let

  gitUser = {
    name = "montoshitaa";
    email = "kristel.montoya.chaves@est.una.ac.cr";
  };

in

{
  # IMPORTANTE: debe coincidir con system.stateVersion de configuration>
  home.stateVersion = "26.05";

  # Tu nombre de usuario
#  home.username = "montoshita";
 # home.homeDirectory = "/home/montoshita";

  # Paquetes solo para tu usuario (no del sistema global)
  home.packages = with pkgs; [
    # Agrega aquí lo que quieras, por ejemplo:
     vscode 
     obsidian
     mongodb-compass
     spotify
     firefox
  ];

  programs.git = {
    enable = true;
    package = pkgs.gitFull;  
    settings. user = gitUser;
    settings.init.defaultBranch = "main";
    settings.pull.rebase = true;
    settings.credential.helper = "libsecret"; 
   };

  # Dejar que home-manager se gestione a sí mismo
  programs.home-manager.enable = true;
}
