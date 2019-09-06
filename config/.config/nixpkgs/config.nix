let
  unstable = import <unstable> {};
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
        catdocx
        connman-gtk
        fzf
        gitAndTools.qgit
        gnome3.totem
        google-chrome
        gparted
        heroku
        inkscape
        keepassx-community
        moka-icon-theme
        mplayer
        nox
        pgadmin
        pinta
        (polybar.override {i3Support = true; })
        qpdfview
        spotify
        universal-ctags
        unstable.kitty
        unstable.neovim
        unstable.slack
        unzip
        vlc
        vscode
        youtube-dl
        zoom-us
      ];
    };
  };
}
