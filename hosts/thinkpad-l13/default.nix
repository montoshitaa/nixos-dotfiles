{ lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "thinkpad-l13";

  programs.nix-ld.enable = true;

  hardware.cpu.intel.updateMicrocode = lib.mkDefault true;

  services.fprintd.enable = true;

  security.pam.services.sudo.fprintAuth = true;
  security.pam.services.login.fprintAuth = true;
  security.pam.services.cosmic-greeter.fprintAuth = true;

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  programs.steam.enable = true;
}
