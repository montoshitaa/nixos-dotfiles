{
  description = "Rust Development Environment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, flake-utils, rust-overlay }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          overlays = [ rust-overlay.overlays.default ];  # overlay aplicado correctamente
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust-bin.stable.latest.default  # rustc + cargo + clippy + fmt
            pkg-config
            openssl
            sqlite
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "🦀 Rust Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            rustc --version
            echo "Cargo: $(cargo --version)"
            echo ""
            echo "📝 Quick Commands:"
            echo "  cargo new --name <proyecto> . → Inicializar nuevo proyecto"
            echo "  cargo build --release         → Compilar release"
            echo "  cargo test                    → Ejecutar tests"
            echo "  cargo fmt                     → Formatear código"
            echo "  cargo clippy                  → Linting"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
          '';
        };
      }
    );
}