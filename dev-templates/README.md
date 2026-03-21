# Development Templates (Nix Flakes)

Este directorio contiene plantillas de Nix Flakes para diferentes entornos de desarrollo. Cada una incluye herramientas, dependencias y configuración específica del lenguaje.

## 📚 Plantillas Disponibles

### ☕ Java (`java/`)
Entorno completo para desarrollo Java con:
- JDK 21
- Maven y Gradle
- Spring Boot CLI
- IntelliJ IDEA Community

**Uso:**
```bash
cd ~/proyectos/mi-proyecto-java
cp ~/nixos-dotfiles/dev-templates/java/flake.nix .
nix flake update
direnv allow
# O manualmente: nix develop
```

**Aliases disponibles:**
- `mci` → mvn clean install
- `mct` → mvn clean test
- `mcp` → mvn clean package
- `mcps` → mvn clean package -DskipTests

---

### 🐍 Python (`python/`)
Entorno completo para desarrollo Python con:
- Python 3.11
- pip y virtualenv
- pytest
- Black, Pylint, mypy
- Poetry para gestión de dependencias

**Uso:**
```bash
cd ~/proyectos/mi-proyecto-python
cp ~/nixos-dotfiles/dev-templates/python/flake.nix .
nix flake update
direnv allow
```

El `shellHook` crea automáticamente un virtual environment.

---

### 📦 Node.js / TypeScript (`nodejs/`)
Entorno completo para desarrollo JavaScript/TypeScript con:
- Node.js 20
- npm, yarn, pnpm
- TypeScript
- ESLint, Prettier
- Bun

**Uso:**
```bash
cd ~/proyectos/mi-proyecto-node
cp ~/nixos-dotfiles/dev-templates/nodejs/flake.nix .
nix flake update
direnv allow
```

**Aliases disponibles:**
- `ni` → npm install
- `nd` → npm run dev
- `nb` → npm run build
- `nt` → npm test

---

### 🦀 Rust (`rust/`)
Entorno completo para desarrollo Rust con:
- Rust stable (última versión)
- Cargo
- rustfmt, clippy
- rust-analyzer
- Soporte para OpenSSL y SQLite

**Uso:**
```bash
cd ~/proyectos/mi-proyecto-rust
cp ~/nixos-dotfiles/dev-templates/rust/flake.nix .
nix flake update
direnv allow
```

---

### ⚙️ C/C++ (`cpp/`)
Entorno completo para desarrollo C/C++ con:
- GCC, G++, Clang
- LLVM
- GDB, LLDB (debuggers)
- CMake, Ninja, Make
- Valgrind (memory analysis)

**Uso:**
```bash
cd ~/proyectos/mi-proyecto-cpp
cp ~/nixos-dotfiles/dev-templates/cpp/flake.nix .
nix flake update
direnv allow
```

---

## 🚀 Uso con Direnv (Automatización)

Para automatizar la carga del ambiente cada vez que entres al directorio:

1. **Copia el template de .envrc:**
   ```bash
   cp ~/nixos-dotfiles/dev-templates/.envrc-template .envrc
   ```

2. **Permite direnv:**
   ```bash
   direnv allow
   ```

3. **Listo:** Cada vez que entres al directorio, el ambiente se cargará automáticamente.

To check if direnv is working:
```bash
direnv status
```

---

## 📋 Workflow típico

```bash
# 1. Crear nuevo proyecto
mkdir mi-proyecto
cd mi-proyecto

# 2. Copiar flake.nix deseado
cp ~/nixos-dotfiles/dev-templates/java/flake.nix .

# 3. Actualizar flake.lock
nix flake update

# 4. Copiar .envrc (opcional pero recomendado)
cp ~/nixos-dotfiles/dev-templates/.envrc-template .envrc

# 5. Permitir direnv
direnv allow

# 6. Verificar entorno
which java
java -version
mvn --version
```

---

## 🔧 Personalizar un Template

Para personalizar un template:

1. Copia el `flake.nix` a tu proyecto
2. Edita `buildInputs` para añadir/remover paquetes
3. Personaliza el `shellHook` con tus aliases o configuraciones
4. Ejecuta `nix flake update` para actualizar dependencias

**Ejemplo:** Añadir PostgreSQL a un proyecto Python:

```nix
buildInputs = with pkgs; [
  python311
  python311Packages.pip
  postgresql  # Añadido
];
```

---

## 🐛 Troubleshooting

### "command not found: java"
- Verifica que direnv esté permitido: `direnv status`
- Recarga el entorno: `direnv reload`
- O entra/sale del directorio

### "nix develop" falla
- Actualiza los flakes: `nix flake update`
- Verifica el archivo `flake.nix`

### direnv no funciona
- Instala direnv (debería estar en tu sistema.nix): `nix-shell -p direnv`
- Add a tu `.zshrc` o `.bashrc`: `eval "$(direnv hook zsh)"`

---

## 📖 Recursos

- [Nix Flakes - NixOS Wiki](https://nixos.wiki/wiki/Flakes)
- [direnv](https://direnv.net/)
- [Flake parts - Useful utilities](https://flake.parts/)

---

**💡 Pro tip:** Puedes usar `nix describe` en cualquier directorio con `flake.nix` para ver qué devShells están disponibles.
