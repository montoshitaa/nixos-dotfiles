{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

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

  system.stateVersion = "26.11";
  nixpkgs.config.allowUnfree = true;

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

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.montoshita = import ../../home/montoshita;
  };
}
