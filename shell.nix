{
  mkShell,

  nixd,
  nixfmt-classic,
}:
mkShell {

  packages = [ nixd nixfmt-classic ];
}
