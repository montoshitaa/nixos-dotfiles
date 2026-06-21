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

  boot.kernelParams = [
    "mem_sleep_default=deep"
    "acpi_osi=!"
    "acpi_osi=\"Linux\""
  ];

  boot.extraModprobeConfig = ''
    options xhci_hcd quirks=0x80
  '';

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
  networking.hostName = "nixos";
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
}
