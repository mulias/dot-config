let
  unstable = import (fetchTarball https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz) { };
  my-python-packages = python-packages: with python-packages; [ pynvim msgpack ];
in {
  allowUnfree = true;

  packageOverrides = pkgs: with pkgs; {
    eliasAll = pkgs.buildEnv {
      name = "elias-all";
      paths = [
        adapta-gtk-theme
        arc-icon-theme
        baobab
        bat
        calibre
        catdocx
        connman-gtk
        direnv
        diskus
        fd
        feh
        ffmpeg
        figlet
        galculator
        gimp
        gitAndTools.qgit
        gnome3.totem
        gparted
        keepassxc
        libreoffice
        links2
        mplayer
        nox
        pandoc
        pdfslicer
        pinta
        (polybar.override { i3Support = true; pulseSupport = true; })
        qpdfview
        racket
        ripgrep
        silver-searcher
        unstable.signal-desktop
        texlive.combined.scheme-full
        texworks
        universal-ctags
        unstable.discord
        unstable.fzf
        unstable.google-chrome
        unstable.kitty
        unstable.neovim
        (unstable.python3.withPackages my-python-packages)
        unstable.vlc
        unstable.zoom-us
        unstable.firefox
        unzip
        youtube-dl
      ];
    };
  };
}
