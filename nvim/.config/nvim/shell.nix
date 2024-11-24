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
  '';
}
