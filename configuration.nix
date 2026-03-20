{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # ═══════════════════════════════════════════════════════════════════════════
  # CONFIGURACIÓN CRÍTICA DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [1] BOOTLOADER - Configuración essencial para arrancar el sistema
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # [2] USUARIO DEL SISTEMA - Cuenta principal con privilegios
  users.users.montoshita = {
    isNormalUser = true;
    description = "Kristel Montoya";
    extraGroups = [ "networkmanager" "wheel" "docker" ];
    group = "users";
  };

  # [3] VERSIÓN DEL ESTADO - IMPORTANTE: sincronizar con home.stateVersion
  system.stateVersion = "26.05";

  # ═══════════════════════════════════════════════════════════════════════════
  # CONFIGURACIÓN DE RED Y CONECTIVIDAD
  # ═══════════════════════════════════════════════════════════════════════════

  # [4] RED - Nombre del host y gestor de conexiones
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # LOCALIZACIÓN E IDIOMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [5] ZONA HORARIA Y LOCALE - Región: Costa Rica
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

  # ═══════════════════════════════════════════════════════════════════════════
  # ENTORNO DE ESCRITORIO (GNOME)
  # ═══════════════════════════════════════════════════════════════════════════

  # [6] DISPLAY MANAGER - Gestor de inicio de sesión
  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  # [7] APLICACIONES GNOME - Solo apps esenciales (sin juegos)
  services.gnome.core-apps.enable = true;
  services.gnome.games.enable = false;

  # [8] TECLADO - Español internacional con acentos en consola
  services.xserver.xkb = {
    layout = "us";
    variant = "intl";
  };
  console.keyMap = "us-acentos";

  # ═══════════════════════════════════════════════════════════════════════════
  # AUDIO Y MULTIMEDIA
  # ═══════════════════════════════════════════════════════════════════════════

  # [9] AUDIO - PipeWire (reemplaza PulseAudio) con soporte múltiple
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # ═══════════════════════════════════════════════════════════════════════════
  # SEGURIDAD Y PERMISOS
  # ═══════════════════════════════════════════════════════════════════════════

  # [10] PERMISOS SUDO - No requiere contraseña para usuarios en 'wheel'
  security.sudo.wheelNeedsPassword = false;

  # ═══════════════════════════════════════════════════════════════════════════
  # HERRAMIENTAS E INFRAESTRUCTURA
  # ═══════════════════════════════════════════════════════════════════════════

  # [11] DOCKER - Virtualización para contenedores
  virtualisation.docker.enable = true;

  # Keyring (para guardar credenciales de git)
programs.seahorse.enable = true;
services.gnome.gnome-keyring.enable = true;

  # [12] NIX FLAKES - Características experimentales para reproducibilidad
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  # [13] IMPRESIÓN - Soporte para conexión de impresoras
  services.printing.enable = true;

  # [14] FLATPAK - Instalador de aplicaciones aisladas
  services.flatpak.enable = true;

  # ═══════════════════════════════════════════════════════════════════════════
  # PAQUETES Y APLICACIONES DEL SISTEMA
  # ═══════════════════════════════════════════════════════════════════════════

  # [15] NAVEGADOR - Firefox para el sistema
  programs.firefox.enable = true;

  # [16] CONFIGURACIÓN NIX - Permitir paquetes no libres (Spotify, etc)
  nixpkgs.config.allowUnfree = true;

  # [17] PAQUETES GLOBALES - Compartidos por todos los usuarios
  environment.systemPackages = with pkgs; [];

}
