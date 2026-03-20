{ config, pkgs, lib, ... }:

# ════════════════════════════════════════════════════════════════════════════════
# HOME-MANAGER: Configuración de entorno de usuario (montoshita)
# ════════════════════════════════════════════════════════════════════════════════

let

  # [GIT] - Identidad para commits
  gitUser = {
    name = "montoshitaa";
    email = "kristel.montoya.chaves@est.una.ac.cr";
  };

  # [PAQUETES] - Aplicaciones del usuario
  userPackages = with pkgs; [
    vscode          # Editor de código
    obsidian        # Gestor de notas
    mongodb-compass # Cliente visual para MongoDB
    spotify         # Música en streaming
    firefox         # Navegador web
  ];

  # [EXTENSIONES GNOME] - Paquetes a instalar
  gnomeExtensionPackages = with pkgs.gnomeExtensions; [
    tiling-shell
    caffeine
    clipboard-history
    top-bar-organizer
    blur-my-shell
    just-perfection
  ];

  # [EXTENSIONES GNOME] - UUIDs para activar en dconf
  gnomeExtensionsEnabled = [
    "tiling-shell@domferr.it"
    "caffeine@patapon.info"
    "clipboard-history@alexsaveau.dev"
    "top-bar-organizer@julian.gse.jsts.xyz"
    "blur-my-shell@aunetx"
    "just-perfection-desktop@just-perfection"
  ];

  # [ALIASES] - Atajos de terminal
  bashAliases = {
    ll  = "ls -l";
    ls  = "ls -a --color=auto";
    gs  = "git status";
    ga  = "git add .";
    gc  = "git commit -m";
    gp  = "git push";
    nrs = "cd /etc/nixos && sudo nixos-rebuild switch --flake .#nixos";
    nrt = "cd /etc/nixos && sudo nixos-rebuild test --flake .#nixos";
  };

in

{
  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 1: ESTADO Y GESTIÓN
  # ══════════════════════════════════════════════════════════════════════════════
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 2: PAQUETES
  # ══════════════════════════════════════════════════════════════════════════════
  home.packages = userPackages ++ gnomeExtensionPackages;

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 3: GIT
  # ══════════════════════════════════════════════════════════════════════════════
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings = {
      user.name  = gitUser.name;
      user.email = gitUser.email;
      init.defaultBranch = "main";
      pull.rebase         = true;
      credential.helper   = "libsecret";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 4: BASH
  # ══════════════════════════════════════════════════════════════════════════════
  programs.bash = {
    enable       = true;
    shellAliases = bashAliases;
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 5: GNOME
  # ══════════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions      = gnomeExtensionsEnabled;
    };
  };
}