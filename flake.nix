{
  description = "Development shell for my Bootstrap Assignment";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
  };

  outputs =
    {
      self,
      nixpkgs,
    }:
    let
      systems = [
        "x86_64-linux"
      ];
      iterOverSystems = nixpkgs.lib.genAttrs systems;
      forSystem =
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          pname = "bootstrap-assignment";
          version = "1.0.0";
          src = ./.;
        in
        {
          devShell = pkgs.mkShell {
            buildInputs = with pkgs; [
              nodejs
            ];
          };

          package = pkgs.stdenv.mkDerivation {
            inherit
              src
              pname
              version
              ;

            postInstall = builtins.readFile ./install.sh;
          };

          formatter = pkgs.nixfmt-tree; # Nix flake formatter. Run `nix fmt` to use
        };
    in
    {
      formatter = iterOverSystems (system: (forSystem system).formatter);

      devShells = iterOverSystems (system: {
        default = (forSystem system).devShell;
      });

      packages = iterOverSystems (system: {
        default = (forSystem system).package;
      });
    };
}
