{
  config,
  pkgs,
  lib,
  ...
}:

{
  # ── Boot ─────────────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  systemd.sleep.settings.Sleep = {
    MemorySleepMode = "deep";
    AllowSuspend = true;
    AllowHybridSleep = true;
    AllowSuspendThenHibernate = true;
  };

  hardware.enableRedistributableFirmware = true;

  # ── Locale ───────────────────────────────────────────────────────
  time.timeZone = "America/Costa_Rica";

  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT = "es_CR.UTF-8";
    LC_MONETARY = "es_CR.UTF-8";
    LC_NAME = "es_CR.UTF-8";
    LC_NUMERIC = "es_CR.UTF-8";
    LC_PAPER = "es_CR.UTF-8";
    LC_TELEPHONE = "es_CR.UTF-8";
    LC_TIME = "es_CR.UTF-8";
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };

  console.keyMap = "us-acentos";

  # ── Networking ───────────────────────────────────────────────────
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ ];
  };

  # ── Bluetooth ────────────────────────────────────────────────────

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
  };

  services.blueman.enable = true;

  hardware.bluetooth.settings = {
    General = {
      Experimental = true;
    };
  };

  # ── Security ─────────────────────────────────────────────────────
  security.sudo.wheelNeedsPassword = true;
  security.rtkit.enable = true;

  # ── Nix ──────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  nix.gc = {
    automatic = true;
    options = "--delete-older-than 30d";
  };

  nix.optimise.automatic = true;

  # ── Audio ────────────────────────────────────────────────────────
  services.pulseaudio.enable = false;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # ── Docker ───────────────────────────────────────────────────────
  virtualisation.docker.enable = true;
  virtualisation.docker.daemon.settings = {
    bip = "192.168.30.1/24";
    "default-address-pools" = [
      {
        base = "10.10.0.0/16";
        size = 24;
      }
    ];
  };
  virtualisation.docker.autoPrune.enable = true;

  # ── Flatpak ──────────────────────────────────────────────────────
  services.flatpak.enable = true;

  # ── Firefox ──────────────────────────────────────────────────────
  programs.firefox = {
    enable = true;
    preferences = {
      "widget.gtk.libadwaita-colors.enabled" = false;
    };
  };

  # ── System programs ──────────────────────────────────────────────
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # ── COSMIC Desktop ──────────────────────────────────────────────
  services.desktopManager.cosmic.enable = true;
  services.displayManager.cosmic-greeter.enable = true;
  services.system76-scheduler.enable = true;
  environment.sessionVariables.COSMIC_DATA_CONTROL_ENABLED = "1";

  # ── Nixpkgs ───────────────────────────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── User ──────────────────────────────────────────────────────────
  users.users.montoshita = {
    isNormalUser = true;
    description = "Kristel Montoya";
    extraGroups = [
      "networkmanager" "wheel" "docker" "dialout"
      "video" "render" "audio"
    ];
    group = "users";
    shell = pkgs.zsh;
  };

  # ── System packages ───────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    btop
    vim
    wget
    curl
    jq
    yq-go
    ripgrep
    fd
    tree
    pciutils
    usbutils
    appimage-run
    tldr
    libsecret
    dnsmasq
    file-roller
    unzip
    unrar
    p7zip
    pavucontrol
  ];

  # ── Home Manager ──────────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.montoshita = import ../home/montoshita;
  };

  system.stateVersion = "26.05";
}
