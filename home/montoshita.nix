{ config, pkgs, lib, inputs, ... }:

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
    gsettings-desktop-schemas
    gtk3
    # Editores e IDEs
    vscode
    #jetbrains.idea-community    # IDE para Java

    # Productividad
    obsidian                    # Gestor de notas

    # Desarrollo
    mongodb-compass             # Cliente visual para MongoDB
    #postman                     # Testing de APIs
    dbeaver-bin                 # Database manager
    docker                      # Containerización
    docker-compose              # Orquestación de contenedores
    antigravity
    #mysql-workbench
    opencode
    pgmodeler

    # Multimedia
    spotify
    firefox
    onlyoffice-desktopeditors

    # Networking
    wireshark
    #nmap
    curl
    #wget

    # Herramientas de desarrollo
    gh                          # GitHub CLI
    lazygit                     # Git TUI
    fastfetch
    tldr
    arduino-ide


  # Seguridad
    mullvad-vpn

    # Wayland
    fuzzel                      # App launcher
    brightnessctl               # Screen brightness
    playerctl                   # Media player controls (next/pause/prev)
    hyprpaper                   # Wallpaper daemon for Hyprland
    libnotify                   # notify-send for toggle-colorscheme
    mako                        # Notification daemon
    polkit_gnome                # Polkit authentication agent
    wl-clipboard                # Wayland clipboard (wl-copy, wl-paste)
    grim                        # Screenshot tool
    slurp                       # Region selection for grim
    qt5.qtwayland               # Qt5 Wayland support
    qt6.qtwayland               # Qt6 Wayland support
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
    toggle-colorscheme = "toggle-colorscheme";  # Cambiar modo claro/oscuro
  };

in

{
  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 1: ESTADO Y GESTIÓN
  # ══════════════════════════════════════════════════════════════════════════════
  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # [Eliminado xdg.portal a nivel de usuario para evitar conflictos con NixOS base]

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 2: PAQUETES
  # ══════════════════════════════════════════════════════════════════════════════
  home.packages = userPackages ++ gnomeExtensionPackages;

  home.sessionVariables = {
    GSETTINGS_SCHEMA_DIR = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}/glib-2.0/schemas:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}/glib-2.0/schemas";
    XDG_DATA_DIRS = "${pkgs.gsettings-desktop-schemas}/share/gsettings-schemas/${pkgs.gsettings-desktop-schemas.name}:${pkgs.gtk3}/share/gsettings-schemas/${pkgs.gtk3.name}:${pkgs.gtk4}/share/gsettings-schemas/${pkgs.gtk4.name}:$XDG_DATA_DIRS";
  };

  # Symlink wallpapers a ~/Pictures/Wallpapers para compatibilidad con Caelestia Shell
  home.file."Pictures/Wallpapers" = {
    source = ../wallpapers;
    recursive = true;
  };

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
      gpg.format          = "ssh";
      user.signingkey     = "~/.ssh/id_ed25519.pub";
      commit.gpgsign      = true;
      gpg.ssh.allowedSignersFile = "~/.config/git/allowed_signers";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 3.5: ARCHIVO DE FIRMANTES SSH PERMITIDOS
  # ══════════════════════════════════════════════════════════════════════════════
  xdg.configFile."git/allowed_signers".text = ''
    ${gitUser.email} ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDvbHIaRrYv9EesUpg0cnwwY9qbvyzmHjGmHANdvgKNw
  '';

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
        opacity = 0.92;
        blur    = true;
        padding = {
          x = 10;
          y = 10;
        };
      };
      font = {
        size = 11.0;
      };
      colors = {
        primary = {
          background = "#ffffff";
          foreground = "#1c1c1c";
        };
        normal = {
          black   = "#1c1c1c";
          red     = "#c51919";
          green   = "#26a269";
          yellow  = "#a2734c";
          blue    = "#3584e4";
          magenta = "#c061cb";
          cyan    = "#33c7de";
          white   = "#d5d5d5";
        };
        bright = {
          black   = "#5e5e5e";
          red     = "#f66151";
          green   = "#33d17a";
          yellow  = "#e5a50a";
          blue    = "#62a0ea";
          magenta = "#dc8add";
          cyan    = "#2ec7e4";
          white   = "#ffffff";
        };
      };
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 8: STARSHIP
  # ══════════════════════════════════════════════════════════════════════════════
  programs.starship.enable = true;

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 9: CAELESTIA SHELL
  # ══════════════════════════════════════════════════════════════════════════════
  programs.caelestia = {
    enable = true;
    systemd.enable = false; # Starting manually from Hyprland
    cli = {
      enable = true;
    };
    settings = {
      bar.scrollActions = {
        workspaces = true;
        volume = true;
        brightness = true;
      };
      services = {
        useTwelveHourClock = true;
        audioIncrement = 0.05;
        brightnessIncrement = 0.05;
      };
      paths.wallpaperDir = "~/Pictures/Wallpapers";
    };
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 10: GTK, TEMA Y GNOME EXTENSIONS
  # ══════════════════════════════════════════════════════════════════════════════
  dconf.settings = {
    "org/gnome/shell" = {
      disable-user-extensions = false;
      enabled-extensions = [
        "caffeine@patapon.info"
        "clipboard-history@alexsaveau.dev"
        "top-bar-organizer@julian.gse.jsts.xyz"
        "blur-my-shell@aunetx"
        "just-perfection-desktop@just-perfection"
        "auto-accent-colour@Wartybix"
      ];
    };

    # Tema claro para GTK apps (Hyprland y GNOME)
    # Usá `toggle-colorscheme` para cambiar entre light/dark sin rebuild
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-light";
      gtk-theme = "Adwaita";
    };
  };
  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 11: HYPRLAND Y WAYLAND
  # ══════════════════════════════════════════════════════════════════════════════
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;
    extraConfig = ''
      # Monitor
      monitor=,preferred,auto,1

      # Input: US ALT International (acentos con AltGr)
      input {
        kb_layout=us
        kb_variant=altgr-intl
        kb_options=lv3:ralt_switch
        touchpad {
          natural_scroll=true
        }
      }

      # General
      general {
        gaps_in=5
        gaps_out=10
        border_size=2
        col.active_border=rgba(ccccccff)
        col.inactive_border=rgba(595959aa)
        cursor_inactive_timeout=3
        no_cursor_warps=true
      }

      # Performance: reducir carga GPU
      decoration {
        blur=false
        drop_shadow=false
      }

      # Animaciones suaves pero ligeras
      animations {
        enabled=true
        bezier=overshot,0.13,0.99,0.29,1.1
        animation=windows,1,4,overshot,slide
        animation=fade,1,4,default
        animation=workspaces,1,3,default,slidevert
      }

      misc {
        disable_hyprland_logo=true
        disable_splash_rendering=true
        animate_manual_resizes=false
        animate_mouse_windowdragging=false
        enable_swallow=false
        vrr=0
      }

      # Wayland env
      env=QT_QPA_PLATFORM,wayland
      env=XDG_CURRENT_DESKTOP,Hyprland

      # Autoinicio
      exec-once=dbus-update-activation-environment --systemd DISPLAY HYPRLAND_INSTANCE_SIGNATURE WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XDG_SESSION_TYPE && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
      exec-once=hyprpaper
      exec-once=mako
      exec-once=/usr/libexec/polkit-gnome-authentication-agent-1
      exec-once=caelestia-shell

      # Variables
      $mod=SUPER
      $terminal=alacritty
      $launcher=fuzzel
      $browser=firefox

      # Lanzadores
      bind=$mod,Return,exec,$terminal
      bind=$mod,D,exec,$launcher
      bind=$mod,B,exec,$browser

      # Cerrar y salir
      bind=$mod,Q,killactive
      bind=$mod,M,exit

      # Pantalla completa y flotante
      bind=$mod,F,fullscreen
      bind=$mod,V,togglefloating
      bind=$mod,P,pseudo

      # Navegación
      bind=$mod,left,movefocus,l
      bind=$mod,right,movefocus,r
      bind=$mod,up,movefocus,u
      bind=$mod,down,movefocus,d

      # Mover ventanas
      bind=$mod SHIFT,left,movewindow,l
      bind=$mod SHIFT,right,movewindow,r
      bind=$mod SHIFT,up,movewindow,u
      bind=$mod SHIFT,down,movewindow,d

      # Espacios de trabajo
      bind=$mod,1,workspace,1
      bind=$mod,2,workspace,2
      bind=$mod,3,workspace,3
      bind=$mod,4,workspace,4
      bind=$mod,5,workspace,5
      bind=$mod,6,workspace,6
      bind=$mod,7,workspace,7
      bind=$mod,8,workspace,8
      bind=$mod,9,workspace,9
      bind=$mod,0,workspace,10

      bind=$mod SHIFT,1,movetoworkspace,1
      bind=$mod SHIFT,2,movetoworkspace,2
      bind=$mod SHIFT,3,movetoworkspace,3
      bind=$mod SHIFT,4,movetoworkspace,4
      bind=$mod SHIFT,5,movetoworkspace,5
      bind=$mod SHIFT,6,movetoworkspace,6
      bind=$mod SHIFT,7,movetoworkspace,7
      bind=$mod SHIFT,8,movetoworkspace,8
      bind=$mod SHIFT,9,movetoworkspace,9
      bind=$mod SHIFT,0,movetoworkspace,10

      # Scratchpad
      bind=$mod,S,togglespecialworkspace,scratchpad
      bind=$mod SHIFT,S,movetoworkspace,special:scratchpad

      # Mouse
      bind=$mod,mouse_down,workspace,e-1
      bind=$mod,mouse_up,workspace,e+1
      bindm=$mod,mouse:272,movewindow
      bindm=$mod,mouse:273,resizewindow

      # Multimedia
      bindl=,XF86AudioRaiseVolume,exec,wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+
      bindl=,XF86AudioLowerVolume,exec,wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-
      bindl=,XF86AudioMute,exec,wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
      bindl=,XF86AudioMicMute,exec,wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
      bindl=,XF86MonBrightnessUp,exec,brightnessctl set 5%+
      bindl=,XF86MonBrightnessDown,exec,brightnessctl set 5%-
      bindl=,XF86AudioNext,exec,playerctl next
      bindl=,XF86AudioPause,exec,playerctl play-pause
      bindl=,XF86AudioPlay,exec,playerctl play-pause
      bindl=,XF86AudioPrev,exec,playerctl previous
    '';
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 12: HYPRPAPER - Wallpaper daemon
  # ══════════════════════════════════════════════════════════════════════════════
  xdg.configFile."hypr/hyprpaper.conf".text = ''
    preload = ~/Pictures/Wallpapers/wallhaven-gw8e9d.png
    wallpaper = ,~/Pictures/Wallpapers/wallhaven-gw8e9d.png
    splash = false
    ipc = on
  '';

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 13: FUZZEL - App launcher (tema claro)
  # ══════════════════════════════════════════════════════════════════════════════
  xdg.configFile."fuzzel/fuzzel.ini".text = ''
    [main]
    background=fffefeff
    text=1c1c1cff
    prompt=3584e4ff
    placeholder=9a9996ff
    input-color=1c1c1cff
    match=3584e4ff
    selection=3584e4ff
    selection-text=ffffffff
    border=3584e4ff
    border-radius=12
    lines=10
    width=40
    terminal=alacritty
    font=JetBrains Mono:size=10
    icons-enabled=yes
  '';

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 14: COLOR-SCHEME TOGGLE
  # ══════════════════════════════════════════════════════════════════════════════
  home.file.".local/bin/toggle-colorscheme" = {
    executable = true;
    text = ''
      #!/usr/bin/env bash
      # Cambia entre modo claro y oscuro para GTK apps
      CURRENT=$(gsettings get org.gnome.desktop.interface color-scheme 2>/dev/null)
      if [[ "$CURRENT" == "'prefer-light'" ]]; then
        gsettings set org.gnome.desktop.interface color-scheme prefer-dark
        notify-send "Color Scheme" "Modo oscuro activado"
      else
        gsettings set org.gnome.desktop.interface color-scheme prefer-light
        notify-send "Color Scheme" "Modo claro activado"
      fi
    '';
  };

  # ══════════════════════════════════════════════════════════════════════════════
  # SECCIÓN 15: SCRIPTS EN PATH
  # ══════════════════════════════════════════════════════════════════════════════
  home.sessionPath = [ "$HOME/.local/bin" ];
}


