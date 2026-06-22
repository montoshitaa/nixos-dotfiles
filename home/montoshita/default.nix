{
  config,
  pkgs,
  lib,
  ...
}:

let
  shellAliases = {
    ll = "ls -lah";
    ls = "ls -a --color=auto";
    ".." = "cd ..";
    "..." = "cd ../..";

    gs = "git status";
    ga = "git add .";
    gaa = "git add --all";
    gc = "git commit -m";
    gp = "git push";
    gpl = "git pull";
    glog = "git log --oneline -10";
    gd = "git diff";
    gb = "git branch -a";
    gco = "git checkout";

    nrs = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild switch --flake .#thinkpad-l13";
    nrt = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild test --flake .#thinkpad-l13";
    nflake = "cd /home/montoshita/nixos-dotfiles && nix flake update";

    mci = "mvn clean install";
    mct = "mvn clean test";
    mcp = "mvn clean package";
    mcps = "mvn clean package -DskipTests";

    py = "python3";
    pip = "pip3";
    venv = "python3 -m venv venv && source venv/bin/activate";

    ni = "npm install";
    nd = "npm run dev";
    nb = "npm run build";

    dps = "docker ps";
    dpsa = "docker ps -a";
    dpc = "docker ps -aq | xargs docker rm";

    cleanbuild = "find . -type d -name 'target' -o -name 'build' -o -name 'dist' | xargs rm -rf";
    ports = "lsof -i -P -n";
    largefile = "du -sh * | sort -rh | head";
  };

  gitUser = {
    name = "montoshitaa";
    email = "kristel.montoya.chaves@est.una.ac.cr";
  };
in
{
  imports = [
    ./plasma.nix
  ];

  home.stateVersion = "26.05";
  programs.home-manager.enable = true;

  # ── Shell ────────────────────────────────────────────────────────
  programs.direnv = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
  };

  programs.starship.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    history = {
      size = 10000;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000;
      expireDuplicatesFirst = true;
      extended = true;
      share = true;
    };
    oh-my-zsh = {
      enable = true;
      plugins = [ "git" "docker" ];
      theme = "robbyrussell";
    };
    shellAliases = shellAliases;
  };

  programs.bash = {
    enable = true;
    shellAliases = shellAliases;
  };

  # ── Terminal ─────────────────────────────────────────────────────
  programs.alacritty = {
    enable = false;
    settings = {
      window = {
        opacity = 0.85;
        blur = true;
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

  # ── Git ──────────────────────────────────────────────────────────
  programs.git = {
    enable = true;
    package = pkgs.gitFull;
    settings.user = {
      name = "Kristel Montoya";
      email = "kristel.montoya.chaves@est.una.ac.cr";
    };
    settings = {
      init.defaultBranch = "main";
      pull.rebase = true;
    };
  };

  # ── Packages ─────────────────────────────────────────────────────
  home.packages = with pkgs; [
    vscode
    antigravity
    opencode
    onlyoffice-desktopeditors
    curl
    fastfetch
    #mullvad-vpn
  ];

  programs.ssh = {
    enable = false;
    enableDefaultConfig = false;
  };

  programs.zed-editor = {
    enable = true;
    enableMcpIntegration = true;
    userSettings = {
      auto_save = "on_focus_change";
      theme = {
        mode = "system";
        light = "Zedokai Light";
        dark = "Zedokai Dark";
      };
    };
    extensions = [
      "java"
      "dockerfile"
      "sql"
      "nix"
      "prisma"
      "docker-compose"
      "ini"
      "pylsp"
      "xml"
      "zedokai"
      "codebook"
      "colored-zed-icons-theme"
    ];
    extraPackages = with pkgs; [
      nixd
      nil
    ];
  };
}
