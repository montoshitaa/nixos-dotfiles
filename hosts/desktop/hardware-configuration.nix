# ═══════════════════════════════════════════════════════════════════
# REEMPLAZÁ este archivo con la salida de:
#
#   sudo nixos-generate-config --show-hardware-config
#
# y pegala aquí reemplazando TODO el contenido.
#
# Revisá que:
#   - nixpkgs.hostPlatform coincida con tu arquitectura
#   - Si usás AMD, eliminá hardware.cpu.intel.updateMicrocode
# ═══════════════════════════════════════════════════════════════════
{ config, lib, pkgs, modulesPath, ... }:

{
  imports =
    [ (modulesPath + "/installer/scan/not-detected.nix")
    ];

  # ── Discos y filesystems ──────────────────────────────────────
  # Reemplazar con la salida de nixos-generate-config

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
