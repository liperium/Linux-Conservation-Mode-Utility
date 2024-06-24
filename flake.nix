{
  description = "Basic template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    gomod2nix.url = "github:nix-community/gomod2nix";
    gomod2nix.inputs.nixpkgs.follows = "nixpkgs";
    gomod2nix.inputs.flake-utils.follows = "utils";
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , gomod2nix
    ,
    }:
    utils.lib.eachDefaultSystem (
      system:
      let
        packageName = "conservationmode-gui";
        pkgs = nixpkgs.legacyPackages.${system};
        conservationmode =
          pkgs.writeShellScriptBin "conservationmode" ''
            ${builtins.readFile ./conservationmode}
          '';

        shellInputs = with pkgs; [
          cargo
          go
          pkg-config
          libayatana-appindicator
          gtk3
          conservationmode
        ];
        appNativeBuildInputs = with pkgs; [ pkg-config ];
        appRuntimeInputs = with pkgs; [
          libayatana-appindicator
          conservationmode
          gtk3
        ];
        appBuildInputs =
          appRuntimeInputs
          ++ (with pkgs; [
            go
            pkg-config
            libayatana-appindicator
            gtk3
          ]);
      in
      {
        packages.${packageName} = pkgs.callPackage ./. {
          inherit (gomod2nix.legacyPackages.${system}) buildGoApplication;
        };

        defaultPackage = self.packages.${packageName};
        defaultApp = utils.lib.mkApp { drv = self.packages.${packageName}; };
        devShells.${packageName} = pkgs.mkShell {
          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = shellInputs ++ appBuildInputs;
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath appRuntimeInputs}"
          '';
        };
        devShell = self.devShells.${system}.${packageName};
      }
    );
}

