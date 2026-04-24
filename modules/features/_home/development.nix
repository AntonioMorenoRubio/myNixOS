{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    podman-compose
    jetbrains.rider
    jetbrains.idea-oss
    codex
    chromium
    tmux
  ];

  programs.git = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    silent = true;
    nix-direnv.enable = true;
  };

  programs.vscode.enable = true;
}
