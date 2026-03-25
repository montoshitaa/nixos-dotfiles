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

  # [PAQUETES] - Aplicaciones del usuario y herramientas de desarrollo
  userPackages = with pkgs; [
    # Editores e IDEs
    vscode
    #jetbrains.idea-community    # IDE para Java

    # Productividad
    obsidian                    # Gestor de notas

    # Desarrollo
    mongodb-compass             # Cliente visual para MongoDB
    #postman                     # Testing de APIs
    dbeaver-bin                 # Database manager

    # Multimedia
    spotify
    firefox
    onlyoffice-desktopeditors

    # Networking
    wireshark
    #nmap
    #curl
    #wget

    # Herramientas de desarrollo
    gh                          # GitHub CLI
    lazygit                     # Git TUI
    fastfetch
    tldr
  ];

  # [EXTENSIONES GNOME] - Paquetes a instalar
  gnomeExtensionPackages = with pkgs.gnomeExtensions; [
    caffeine
    clipboard-history
    top-bar-organizer
    blur-my-shell
    just-perfection
    auto-accent-colour
    arcmenu
  ];

  # [EXTENSIONES GNOME] - UUIDs para activar en dconf
  gnomeExtensionsEnabled = [
    "caffeine@patapon.info"
    "clipboard-history@alexsaveau.dev"
    "top-bar-organizer@julian.gse.jsts.xyz"
    "blur-my-shell@aunetx"
    "just-perfection-desktop@just-perfection"
    "auto-accent-colour@Wartybix"
  ];

  # [ALIASES] - Atajos de terminal para desarrollo
  bashAliases = {
    # Sistema
    ll   = "ls -lah";
    ls   = "ls -a --color=auto";
    ".." = "cd ..";
    "..." = "cd ../..";

    # Git
    gs   = "git status";
    ga   = "git add .";
    gaa  = "git add --all";
    gc   = "git commit -m";
    gp   = "git push";
    gpl  = "git pull";
    glog = "git log --oneline -10";
    gd   = "git diff";
    gb   = "git branch -a";
    gco  = "git checkout";

    # NixOS
    nrs   = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild switch --flake .#nixos";
    nrt   = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild test --flake .#nixos";
    nflake = "cd /home/montoshita/nixos-dotfiles && nix flake update";

    # Java
    mci  = "mvn clean install";
    mct  = "mvn clean test";
    mcp  = "mvn clean package";
    mcps = "mvn clean package -DskipTests";

    # Python
    py   = "python3";
    pip  = "pip3";
    venv = "python3 -m venv venv && source venv/bin/activate";

    # Node.js
    ni = "npm install";
    nd = "npm run dev";
    nb = "npm run build";

    # Docker
    dps  = "docker ps";
    dpsa = "docker ps -a";
    dpc  = "docker ps -aq | xargs docker rm";

    # Utilidades
    cleanbuild = "find . -type d -name 'target' -o -name 'build' -o -name 'dist' | xargs rm -rf";
    ports      = "lsof -i -P -n";
    largefile  = "du -sh * | sort -rh | head";
  };

in

{
  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 1: ESTADO Y GESTIÓN
  # ══════════════════════════════════════════════════════════════════════════════
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;
  
  # Permitir paquetes no libres
  nixpkgs.config.allowUnfree = true;

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
      user.name           = gitUser.name;
      user.email          = gitUser.email;
      init.defaultBranch  = "main";
      pull.rebase         = true;
      credential.helper   = "libsecret";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 4: DIRENV
  # ══════════════════════════════════════════════════════════════════════════════
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration  = true;
    nix-direnv.enable     = true;
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 5: ZSH
  # ══════════════════════════════════════════════════════════════════════════════
  programs.zsh = {
    enable                    = true;
    enableCompletion          = true;
    autosuggestion.enable     = true;
    syntaxHighlighting.enable = true;
    history = {
      size                 = 10000;
      path                 = "${config.xdg.dataHome}/zsh/history";
      save                 = 10000;
      expireDuplicatesFirst = true;
      extended             = true;
      share                = true;
    };
    oh-my-zsh = {
      enable  = true;
      plugins = [
        "git"
        "docker"
      ];
      theme = "robbyrussell";
    };
    shellAliases = bashAliases;
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 6: BASH
  # ══════════════════════════════════════════════════════════════════════════════
  programs.bash = {
    enable       = true;
    shellAliases = bashAliases;
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 7: ALACRITTY
  # ══════════════════════════════════════════════════════════════════════════════
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.85;
        blur    = true;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        size = 11.0;
      };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 8: STARSHIP
  # ══════════════════════════════════════════════════════════════════════════════
  programs.starship.enable = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 9: GNOME - Configuración de extensiones
  # ══════════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = gnomeExtensionsEnabled;
    };
  };
}