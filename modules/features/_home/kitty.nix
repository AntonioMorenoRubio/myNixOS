{ pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      name = "Iosevka Nerd Font";
      size = 12;
    };
    settings = {
      scrollback_lines = 10000;
      enable_audio_bell = false;
      copy_on_select = "clipboard";
    };
    themeFile = "Catppuccin-Mocha";
  };
}
