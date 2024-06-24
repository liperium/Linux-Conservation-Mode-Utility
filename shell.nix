{ pkgs ? (
    let
      inherit (builtins) fetchTree fromJSON readFile;
      inherit ((fromJSON (readFile ./flake.lock)).nodes) nixpkgs gomod2nix;
    in
    import (fetchTree nixpkgs.locked) {
      overlays = [
        (import "${fetchTree gomod2nix.locked}/overlay.nix")
      ];
    }
  )
, mkGoEnv ? pkgs.mkGoEnv
, gomod2nix ? pkgs.gomod2nix
}:

let
  goEnv = mkGoEnv { pwd = ./.; };
  conservationmode =
    pkgs.writeShellScriptBin "conservationmode" ''
      ${builtins.readFile ./conservationmode}
    '';
in
pkgs.mkShellNoCC {
  packages = with pkgs;[
    goEnv
    gomod2nix
    pkg-config
    libayatana-appindicator
    gtk3
    conservationmode
  ];
  CONSERVATION_TEST_ENV = 1;
}
