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

  system.stateVersion = "26.05";
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    gitFull
    fzf
    ripgrep
    htop
    ncdu
    unzip
    zip
    openssh
  ];

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    users.montoshita = import ../../home/montoshita;
  };
}
