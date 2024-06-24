{
  description = "Basic template";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    utils.url = "github:numtide/flake-utils";
    naersk.url = "github:nmattia/naersk";
    inputs.gomod2nix.url = "github:nix-community/gomod2nix";
  };

  outputs =
    { self
    , nixpkgs
    , utils
    , naersk
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
          gomod2nix
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
        packages.${packageName} = naersk.lib.${system}.buildPackage {
          pname = packageName;
          root = ./.;
          nativeBuildInputs = appNativeBuildInputs;
          buildInputs = appBuildInputs;
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

