{
  description = "Node.js / TypeScript Development Environment";

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
            nodejs_20                    # Incluye npm
            yarn
            pnpm
            bun
            nodePackages.typescript
            nodePackages.prettier
            nodePackages.eslint
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "📦 Node.js / TypeScript Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            node --version
            echo "Npm:  $(npm --version)"
            echo "Yarn: $(yarn --version)"
            echo ""
            echo "📝 Quick Commands:"
            echo "  ni          → npm install"
            echo "  nd          → npm run dev"
            echo "  nb          → npm run build"
            echo "  nt          → npm test"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            alias ni="npm install"
            alias nd="npm run dev"
            alias nb="npm run build"
            alias nt="npm test"
          '';
        };
      }
    );
}