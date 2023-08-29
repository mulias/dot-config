# Lua nix env
{ pkgs ? import <nixpkgs> {} }:

with pkgs;

let
  unstable = import <unstable> {};
in

mkShell {
  buildInputs = [
    unstable.stylua
    unstable.sumneko-lua-language-server
  ];

  shellHook = ''
    export NVIM_NVIM_LUA_LSP=true
    export NVIM_STYLUA_LSP=true
    export LUA_LS_ROOT_PATH=$(nix eval nixos.sumneko-lua-language-server.outPath)
    export LUA_LS_MAIN_FILE="$LUA_LS_ROOT_PATH/extras/main.lua"
    export LUA_LS_EXECUTABLE=lua-language-server
  '';
}
