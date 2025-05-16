# shell.nix
{ pkgs ? import <nixpkgs> {} }:

let
  gtk = pkgs.gtk4;
in
pkgs.mkShell {
  buildInputs = [
    gtk
    pkgs.pkg-config
    # pkgs.gcc
  ];

  shellHook = ''
    export PKG_CONFIG_PATH=${gtk.dev}/lib/pkgconfig
    zsh
    echo "GTK 4 dev environment ready."
  '';
}
