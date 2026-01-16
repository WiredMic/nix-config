{
  config,
  lib,
  pkgs,
  userSettings,
  ...
}:
{
  imports = [ ];

  # XDG
  xdg = {
    cacheHome = "${config.home.homeDirectory}/.cache";
    configHome = "${config.home.homeDirectory}/.config/";
    dataHome = "${config.home.homeDirectory}/.local/share/";
    stateHome = "${config.home.homeDirectory}/.local/state";
  };

  # Environment Variables to always set at login

  home.sessionVariables = {
    # flatpak
    XDG_DATA_DIRS = "$XDG_DATA_DIRS:/usr/share:/var/lib/flatpak/exports/share:$HOME/.local/share/flatpak/exports/share";
  };

  home.sessionVariables = {
    EDITOR = "${userSettings.editor}";
    VISUAL = "$EDITOR";
    PLATFORMIO_CORE_DIR = "${config.xdg.configHome}/platformio";
    TLDR_CACHE_DIR = "${config.xdg.configHome}/tldr";

    PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
    IPYTHONDIR = "${config.xdg.configHome}/ipython";
    JUPYTER_CONFIG_DIR = "${config.xdg.configHome}/jupyter";

    HISTFILE = "${config.xdg.stateHome}/bash/history";
    DOTNET_CLI_HOME = "${config.xdg.dataHome}/dotnet";
  };

  xdg.configFile."python/pythonrc".text = ''
    #!/usr/bin/env python3
    # This entire thing is unnecessary post v3.13.0a3
    # https://github.com/python/cpython/issues/73965

    def is_vanilla() -> bool:
    	""" :return: whether running "vanilla" Python """
    	import sys
    	return not hasattr(__builtins__, '__IPYTHON__') and 'bpython' not in sys.argv[0]


    def setup_history():
    	""" read and write history from state file """
    	import os
    	import atexit
    	import readline
    	from pathlib import Path

    	# https://specifications.freedesktop.org/basedir-spec/basedir-spec-latest.html#variables
    	if state_home := os.environ.get('XDG_STATE_HOME'):
    		state_home = Path(state_home)
    	else:
    		state_home = Path.home() / '.local' / 'state'
    	if not state_home.is_dir():
    		print("Error: XDG_SATE_HOME does not exist at", state_home)

    	history: Path = state_home / 'python_history'

    	# https://github.com/python/cpython/issues/105694
    	if not history.is_file():
    		with open(history,"w") as f:
    			f.write("_HiStOrY_V2_" + "\n\n") # breaks on macos + python3 without this.

    	readline.read_history_file(history)
    	atexit.register(readline.write_history_file, history)


    if is_vanilla():
    	setup_history()

  '';
}
