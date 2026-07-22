{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "thinkpad-l13";

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
  };
}
