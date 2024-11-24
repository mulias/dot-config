let
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  my-python-packages = python-packages: with python-packages; [ pynvim msgpack ];
in {
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    eliasAll = pkgs.buildEnv {
      name = "elias-all";
      paths = [
        (python3.withPackages my-python-packages)
        calibre
        galculator
        gimp
        gitAndTools.qgit
        gparted
        keepassxc
        libreoffice
        megasync
        nox
        pdfslicer
        pinta
        qpdfview
        texlive.combined.scheme-full
        texworks
        transmission_4-gtk
        unstable.discord
        unstable.firefox
        unstable.fzf
        unstable.google-chrome
        unstable.kitty
        unstable.neovim
        unstable.signal-desktop
        unstable.zed-editor
        vscode
        dbeaver-bin
        git-absorb
      ];
    };
  };
}
