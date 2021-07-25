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
        ag
        arc-icon-theme
        baobab
        bat
        calibre
        catdocx
        connman-gtk
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
        # heroku
        # inkscape
        keepassx-community
        mplayer
        nox
        pandoc
        # pgadmin
        pinta
        (polybar.override { i3Support = true; pulseSupport = true; })
        # postman
        qpdfview
        racket
        ripgrep
        # spotify
        texlive.combined.scheme-full
        texworks
        universal-ctags
        discord
        unstable.fzf
        unstable.google-chrome
        unstable.kitty
        # unstable.neovim
        (unstable.python3.withPackages my-python-packages)
        unstable.slack
        unstable.vlc
        unstable.zoom-us
        unzip
        # vscode
        # watchexec
        # youtube-dl
      ];
    };
  };
}
