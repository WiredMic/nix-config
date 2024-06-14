{
  pkgs,
  config,
  ...
}:
{
  home.sessionPath = [
    "\${xdg.configHome}/cargo/bin"
  ];
}
