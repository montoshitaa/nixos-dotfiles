{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "desktop";

  # Ajustá según tu GPU:
  #
  # NVIDIA:
  #   services.xserver.videoDrivers = [ "nvidia" ];
  #   hardware.nvidia = {
  #     modesetting.enable = true;
  #     powerManagement.enable = true;
  #     open = false;
  #     nvidiaSettings = true;
  #     package = config.boot.kernelPackages.nvidiaPackages.stable;
  #   };
  #
  # AMD:
  #   services.xserver.videoDrivers = [ "amdgpu" ];
  #   hardware.graphics = {
  #     enable = true;
  #     extraPackages = with pkgs; [ amdvlk ];
  #   };
}
