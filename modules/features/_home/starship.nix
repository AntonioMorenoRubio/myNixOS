{ pkgs, ... }: {
  programs.starship = {
    enable = true;
    settings = {
      add_newline = true;
      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
      };
      git_branch.symbol = " ";
      git_status = {
        ahead = "⇡\${ahead_count}";
        behind = "⇣\${behind_count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified = "!\${count}";
        untracked = "?\${count}";
        staged = "+\${count}";
      };
      nix_shell.symbol = " ";
      rust.symbol = " ";
      nodejs.symbol = " ";
      directory.truncation_length = 3;
    };
  };
}
