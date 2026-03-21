{
  description = "C/C++ Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            gcc          # Incluye g++ y libstdc++
            clang        # Compilador alternativo
            gdb          # Debugger GNU
            lldb         # Debugger LLVM
            valgrind     # Análisis de memoria
            cmake        # Build system
            gnumake      # Make
            ninja        # Build system alternativo
            pkg-config   # Gestión de dependencias
            boost        # Librería C++
            openssl      # Criptografía
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "⚙️  C/C++ Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "GCC:    $(gcc --version | head -n1)"
            echo "Clang:  $(clang --version | head -n1)"
            echo "CMake:  $(cmake --version | head -n1)"
            echo "GDB:    $(gdb --version | head -n1)"
            echo ""
            echo "📝 Quick Commands:"
            echo "  cmake -B build && cd build && make → Compilar con CMake"
            echo "  gcc -o