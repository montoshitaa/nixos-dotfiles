# Guía: Agregar un nuevo host a los dotfiles

Esta guía explica cómo agregar una nueva máquina (por ejemplo, una computadora de escritorio) con diferente hardware al repositorio de dotfiles.

La configuración común (usuario, paquetes base, home-manager, KDE, etc.) ya está en `modules/default.nix`. Cada host solo define su hardware y hostname.

## Requisitos previos

- Tener NixOS instalado en la nueva máquina
- Este repositorio clonado
- Saber si la arquitectura es `x86_64-linux` o `aarch64-linux`

## Paso 1: Generar el hardware-configuration.nix

En la nueva máquina, ejecutá:

```bash
sudo nixos-generate-config --show-hardware-config
```

Esto imprime la configuración de hardware detectada (discos, módulos del kernel, CPU, etc.). Copiá esa salida.

> Alternativa: si ya tenés un `/etc/nixos/hardware-configuration.nix` generado durante la instalación, podés copiarlo directamente.

## Paso 2: Crear el directorio del host

En este repositorio, dentro de `hosts/`, creá una carpeta con el nombre de tu nueva máquina:

```bash
mkdir -p hosts/desktop
```

> **Convención**: usá un nombre descriptivo sin espacios (ej: `desktop`, `laptop`, `server`).

## Paso 3: Crear `hosts/<nombre>/hardware-configuration.nix`

Creá el archivo con el contenido generado en el Paso 1. Revisá que:
- `nixpkgs.hostPlatform` coincida con tu arquitectura (`x86_64-linux` o `aarch64-linux`)
- Si usás AMD, eliminá `hardware.cpu.intel.updateMicrocode`

## Paso 4: Crear `hosts/<nombre>/default.nix`

El archivo es **mínimo** porque toda la configuración común (usuario, paquetes, home-manager, KDE, etc.) se hereda de `modules/default.nix`. Solo necesitás imports, hostname y paquetes o configuraciones específicas del host:

```nix
# hosts/desktop/default.nix
{ pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ../../modules
  ];

  networking.hostName = "desktop";

  # Paquetes extra solo para este host
  environment.systemPackages = with pkgs; [
    steam
    lutris
  ];
}
```

### Ajustes específicos por tipo de máquina

**Desktop con GPU NVIDIA:**
```nix
services.xserver.videoDrivers = [ "nvidia" ];
hardware.nvidia = {
  modesetting.enable = true;
  powerManagement.enable = true;
  open = false;
  nvidiaSettings = true;
  package = config.boot.kernelPackages.nvidiaPackages.stable;
};
```

**Desktop con GPU AMD:**
```nix
services.xserver.videoDrivers = [ "amdgpu" ];
hardware.graphics = {
  enable = true;
  extraPackages = with pkgs; [ amdvlk ];
};
```

**Otra laptop:**
```nix
services.tlp.enable = true;
services.fprintd.enable = true;
```

## Paso 5: Registrar el host en `flake.nix`

Agregá tu nuevo host en `nixosConfigurations`:

```nix
nixosConfigurations.desktop = mkSystem ./hosts/desktop;
```

Si tu máquina tiene arquitectura diferente, parametrizá `mkSystem`:

```nix
mkSystem = system: hostPath: nixpkgs.lib.nixosSystem {
  inherit system;
  modules = [
    hostPath
    home-manager.nixosModules.home-manager
  ];
};
```

Y luego:
```nix
nixosConfigurations.thinkpad-l13 = mkSystem "x86_64-linux" ./hosts/thinkpad-l13;
nixosConfigurations.desktop = mkSystem "x86_64-linux" ./hosts/desktop;
```

## Paso 6: Build y test

```bash
sudo nixos-rebuild switch --flake .#desktop
sudo nixos-rebuild test --flake .#desktop    # solo test, no aplica
```

## Paso 7: Agregar aliases

En `home/montoshita/default.nix`, agregá:

```nix
nrs-desktop = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild switch --flake .#desktop";
nrt-desktop = "cd /home/montoshita/nixos-dotfiles && sudo nixos-rebuild test --flake .#desktop";
```

---

## Resumen

| Acción | Archivo |
|--------|---------|
| Nuevo | `hosts/<nombre>/hardware-configuration.nix` |
| Nuevo | `hosts/<nombre>/default.nix` (~10 líneas) |
| Modificar | `flake.nix` (una línea por host) |
| Opcional | `home/montoshita/default.nix` (aliases) |

## Estructura final

```
hosts/
├── thinkpad-l13/
│   ├── default.nix
│   └── hardware-configuration.nix
└── desktop/
    ├── default.nix
    └── hardware-configuration.nix
```
