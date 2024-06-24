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
, buildGoApplication ? pkgs.buildGoApplication
}:

buildGoApplication rec {
  pname = "tray-conservationmode";
  version = "0.1";
  pwd = ./.;
  src = ./.;
  modules = ./gomod2nix.toml;
  nativeBuildInputs = [ pkgs.pkg-config ];
  buildInputs = with pkgs;[
    pkg-config
    libayatana-appindicator
    gtk3
  ];
  installPhase = ''
    runHook preInstall

    mkdir -p $out/assets
    mkdir -p $out/bin
    dir="$GOPATH/bin"
    [ -e "$dir" ] && cp -r $dir $out
    cp ${pwd}/assets/* $out/assets

    runHook postInstall
  '';
}
