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
        catdocx
        chromium
        connman-gtk
        fzf
        gitAndTools.qgit
        gparted
        keepassx-community
        moka-icon-theme
        mplayer
        nox
        pinta
        (polybar.override {i3Support = true; })
        qpdfview
        universal-ctags
        unstable.kitty
        unstable.neovim
        unstable.slack
        vlc
        vscode
        youtube-dl
      ];
    };
  };
}
