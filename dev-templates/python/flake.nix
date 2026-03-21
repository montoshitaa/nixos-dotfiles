{
  description = "Python Development Environment";

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
            python311                    # Incluye pip y venv
            python311Packages.pytest
            python311Packages.black
            python311Packages.pylint
            python311Packages.mypy
            poetry
            pre-commit
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🐍 Python Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            python3 --version
            echo "Pip:  $(pip3 --version)"
            echo ""
            echo "📝 Quick Commands:"
            echo "  venv    → Crear virtual environment"
            echo "  pytest  → Ejecutar tests"
            echo "  black   → Formatear código"
            echo "  pylint  → Linting"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            if [ ! -d "venv" ]; then
              python3 -m venv venv
            fi
            source venv/bin/activate
          '';
        };
      }
    );
}