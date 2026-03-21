{
  description = "Java Development Environment";

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
            jdk21
            maven
            gradle
            spring-boot
          ];

          shellHook = ''
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            echo "☕ JAVA Development Environment"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            java -version 2>&1 | head -n1
            echo "Maven: $(mvn -v | head -n1)"
            echo ""
            echo "📝 Quick Commands:"
            echo "  mci     → mvn clean install"
            echo "  mct     → mvn clean test"
            echo "  mcp     → mvn clean package"
            echo "  mcps    → mvn clean package -DskipTests"
            echo "  spring  → spring run"
            echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
            alias mci="mvn clean install"
            alias mct="mvn clean test"
            alias mcp="mvn clean package"
            alias mcps="mvn clean package -DskipTests"
          '';
        };
      }
    );
}