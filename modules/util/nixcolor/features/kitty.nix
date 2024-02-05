{ pkgs, config, ... }:
{

  # https://mipmip.github.io/home-manager-option-search/?query=kitty
  # https://sw.kovidgoyal.net/kitty/conf/
  programs.kitty = {
    enable = true;

    shellIntegration.enableZshIntegration = true;
    
    settings = {
        font_family = "JetBrainsMono";
        font_size = "14";
        bold_font = "auto";
        italic_font = "auto";
        bold_italic_font = "auto";

        enable_audio_bell = false;
        scrollback_lines = -1;
        tab_bar_edge = "top";
        allow_remote_control = "yes";
        shell_integration = "enabled";
        macos_option_as_alt = "yes";
        
        background_opacity = "0.8";
        foreground = "#${config.colorScheme.palette.base05}";
        background = "#${config.colorScheme.palette.base00}";

        # Black
        color0 = "#${config.colorScheme.palette.base00}";
        color8 = "#${config.colorScheme.palette.base08}";

        # Red
        color1 = "#${config.colorScheme.palette.base01}";
        color9 = "#${config.colorScheme.palette.base09}";

        # green
        color2 = "#${config.colorScheme.palette.base02}";
        color10 = "#${config.colorScheme.palette.base0A}";

        # yellow
        color3 = "#${config.colorScheme.palette.base03}";
        color11 = "#${config.colorScheme.palette.base0B}";

        # blue
        color4 = "#${config.colorScheme.palette.base04}";
        color12 = "#${config.colorScheme.palette.base0C}";
  
        # magenta
        color5 = "#${config.colorScheme.palette.base05}";
        color13 = "#${config.colorScheme.palette.base0D}";

        # cyan
        color6 = "#${config.colorScheme.palette.base06}";
        color14 = "#${config.colorScheme.palette.base0E}";

        # white 
        color7 = "#${config.colorScheme.palette.base07}";
        color15 = "#${config.colorScheme.palette.base0F}";

      };
  };

}

