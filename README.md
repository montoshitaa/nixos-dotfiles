# nixos-dotfiles

Dotfiles y configuración declarativa de NixOS para mis máquinas personales.

## Estructura del repositorio

```
├── flake.nix                  # Entrada principal: inputs, outputs, hosts
├── flake.lock                 # Versiones fijadas de dependencias
├── hosts/                     # Configuración por máquina
│   ├── thinkpad-l13/          #   default.nix + hardware-configuration.nix
│   └── desktop/               #   default.nix + hardware-configuration.nix
├── modules/                   # Configuración compartida entre todos los hosts
│   └── default.nix            #   boot, locale, network, audio, docker, COSMIC,
│                              #   usuario, paquetes base, home-manager
├── home/                      # Home Manager (configuración de usuario)
│   └── montoshita/            #   shell, git, paquetes
├── dev-templates/             # Templates para `nix flake init -t`
│   ├── cpp/ java/ nodejs/ python/ rust/
│   └── README.md
├── docs/                      # Documentación
├── wallpapers/                # Fondos de pantalla
└── README.md
```

## Cómo navegar y modificar

### ¿Querés cambiar algo del sistema (boot, red, audio, locale, docker, usuario, paquetes base)?

→ **`modules/default.nix`** — configuración compartida entre todos los hosts.

### ¿Querés cambiar paquetes o configuraciones de una máquina específica?

→ **`hosts/<host>/default.nix`** — solo hostname + hardware + extras específicos.

### ¿Querés cambiar tu shell, git, alias, editor o paquetes de usuario?

→ **`home/montoshita/default.nix`** — configuración de Home Manager.

### ¿Querés cambiar la apariencia de COSMIC?

→ Los ajustes de COSMIC se configuran desde la aplicación de Configuración del sistema o mediante dconf.

### ¿Querés agregar una máquina nueva?

→ Leé **`docs/nuevo-host-guia.md`** — guía paso a paso.

### ¿Querés rebuild después de cambios?

```bash
sudo nixos-rebuild switch --flake .#thinkpad-l13
# o con el alias:
nrs
```

### ¿Querés actualizar el lockfile?

```bash
nix flake update
# o con el alias:
nflake
```

## Flujo de trabajo típico

1. Editá el archivo correspondiente según lo que querés cambiar
2. Ejecutá `sudo nixos-rebuild switch --flake .#<host>` (o `nrs`)
3. Si algo falla, usá `nrt` (test sin aplicar) para debuggear
4. Hacé commit de los cambios

## Hosts actuales

| Host | Arquitectura | Tipo |
|------|--------------|------|
| `thinkpad-l13` | `x86_64-linux` | Laptop (ThinkPad L13) |
| `desktop` | `x86_64-linux` | Desktop (AMD) |

## Templates disponibles

```bash
nix flake init -t .#cpp       # C/C++ con CMake, GDB, Valgrind
nix flake init -t .#java      # Java 21 con Maven, Gradle, Spring
nix flake init -t .#nodejs    # Node.js 20 con TypeScript, Bun
nix flake init -t .#python    # Python 3.11 con pytest, Black, mypy
nix flake init -t .#rust      # Rust con rust-analyzer
```

## Notas

- El system stateVersion actual es `26.05`
- Se usa `nixos-unstable` como canal
- El formatter del flake es `nixfmt`
