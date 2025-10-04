{ pkgs ? import <nixpkgs> { } }:

pkgs.mkShell { packages = [ pkgs.nixd pkgs.nixfmt-classic ]; }
