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
  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

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

  # ── Security ─────────────────────────────────────────────────────
  security.sudo.wheelNeedsPassword = false;
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
  programs.firefox.enable = true;

  # ── System programs ──────────────────────────────────────────────
  programs.zsh.enable = true;
  programs.dconf.enable = true;

  # ── KDE Plasma 6 ─────────────────────────────────────────────────
  services.desktopManager.plasma6.enable = true;
  services.displayManager.plasma-login-manager.enable = true;
  security.pam.services.sddm.enableKwallet = true;

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
    steam-run
    appimage-run
    tldr
    libsecret
    dnsmasq
    file-roller
    unzip
    unrar
    p7zip
  ];

  # ── Home Manager ──────────────────────────────────────────────────
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.montoshita = import ../home/montoshita;
  };

  system.stateVersion = "26.11";
}
