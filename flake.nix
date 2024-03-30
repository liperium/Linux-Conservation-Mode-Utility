{
 description = "Basic dev flake";

 inputs.nixpkgs.url = "github:NixOS/nixpkgs";

 outputs = { self, nixpkgs }: {
   devShell.x86_64-linux = with nixpkgs.legacyPackages.x86_64-linux; mkShell {
     buildInputs = [
        go
       # zsh
     ];
   };
 };
}