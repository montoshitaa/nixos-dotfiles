{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # CONFIGURACIÓN CRÍTICA DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [1] BOOTLOADER
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # [2] USUARIO DEL SISTEMA
  users.users.montoshita = {
    isNormalUser = true;
    description  = "Kristel Montoya";
    extraGroups  = [ "networkmanager" "wheel" "docker" "dialout" "video" "render" "audio" ];
    group        = "users";
    shell        = pkgs.zsh;
  };

  # [3] VERSIÓN DEL ESTADO
  system.stateVersion = "26.05";

  # ═══════════════════════════════════════════════════════════════════════════
  # RED Y CONECTIVIDAD
  # ═══════════════════════════════════════════════════════════════════════════

  # [4] RED
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [];  # Sin puertos expuestos
  };


  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALIZACIÓN E IDIOMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [5] ZONA HORARIA Y LOCALE
  time.timeZone = "America/Costa_Rica";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "es_CR.UTF-8";
    LC_IDENTIFICATION = "es_CR.UTF-8";
    LC_MEASUREMENT    = "es_CR.UTF-8";
    LC_MONETARY       = "es_CR.UTF-8";
    LC_NAME           = "es_CR.UTF-8";
    LC_NUMERIC        = "es_CR.UTF-8";
    LC_PAPER          = "es_CR.UTF-8";
    LC_TELEPHONE      = "es_CR.UTF-8";
    LC_TIME           = "es_CR.UTF-8";
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # ENTORNO DE ESCRITORIO (GNOME)
  # ═══════════════════════════════════════════════════════════════════════════

  # [6] DISPLAY MANAGER
  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # [7] APLICACIONES GNOME
  services.gnome.core-apps.enable = true;
  services.gnome.games.enable = false;

  # [8] TECLADO
  services.xserver.xkb = {
    layout  = "us";
    variant = "intl";
  };
  console.keyMap = "us-acentos";

  # ═══════════════════════════════════════════════════════════════════════════
  # AUDIO Y MULTIMEDIA
  # ═══════════════════════════════════════════════════════════════════════════

  # [9] AUDIO - PipeWire
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable           = true;
    alsa.enable      = true;
    alsa.support32Bit = true;
    pulse.enable     = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SEGURIDAD Y PERMISOS
  # ═══════════════════════════════════════════════════════════════════════════

  # [10] PERMISOS SUDO - No requiere contraseña para usuarios en 'wheel'
  security.sudo.wheelNeedsPassword = false;

  # ═══════════════════════════════════════════════════════════════════════════
  # HERRAMIENTAS E INFRAESTRUCTURA
  # ═══════════════════════════════════════════════════════════════════════════

  # [10] DOCKER
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

  # [11] KEYRING - Credenciales de git
  programs.seahorse.enable = true;
  services.gnome.gnome-keyring.enable = true;

  # [12] NIX FLAKES
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # [13] IMPRESIÓN
  services.printing.enable = true;

  # [14] FLATPAK
  services.flatpak.enable = true;

  # [15] ZSH
  programs.zsh.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # PAQUETES Y APLICACIONES DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [16] NAVEGADOR
  programs.firefox.enable = true;

  # [17] PAQUETES NO LIBRES
  nixpkgs.config.allowUnfree = true;

  # [18] PAQUETES GLOBALES - Solo herramientas base del sistema
  environment.systemPackages = with pkgs; [
    # Control de versiones
    gitFull

    # Herramientas base
    fzf
    ripgrep
    htop
    ncdu
    unzip
    zip
    openssh
    docker-compose
  ];
}