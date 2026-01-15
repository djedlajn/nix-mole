{
  description = "Mole - A CLI tool for cleaning and optimizing macOS";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachSystem [ "aarch64-darwin" "x86_64-darwin" ] (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        mole = pkgs.callPackage ./package.nix { };
      in
      {
        packages = {
          default = mole;
          mole = mole;
        };

        apps.default = {
          type = "program";
          program = "${mole}/bin/mole";
        };

        devShells.default = pkgs.mkShell {
          packages = [ mole ];
        };
      }
    )
    // {
      overlays.default = final: prev: {
        mole = final.callPackage ./package.nix { };
      };
    };
}
