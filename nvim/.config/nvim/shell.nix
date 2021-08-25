# Lua nix env
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

mkShell {
  buildInputs = [ stylua sumneko-lua-language-server ];

  shellHook = ''
    export SUMNEKO_ROOT_PATH=$(nix eval nixos.sumneko-lua-language-server.outPath)
    export SUMNEKO_MAIN_FILE="$SUMNEKO_ROOT_PATH/extras/main.lua"
    export SUMNEKO_EXECUTABLE=lua-language-server
  '';
}
