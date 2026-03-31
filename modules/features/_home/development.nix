{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    podman-compose
    jetbrains.rider
  ];

  programs.git = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode.enable = true;
}
