{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    podman-compose
    jetbrains.rider
    jetbrains.idea
    codex
    chromium
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
