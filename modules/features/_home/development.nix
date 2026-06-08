{ pkgs, ... }: {
  home.packages = with pkgs; [
    # DevOps
    git
    gh
    podman
    podman-desktop
    podman-tui
    podman-compose

    # SDKs
    dotnet-sdk_10

    # IDEs
    jetbrains.rider
    jetbrains.idea-oss
    jetbrains.webstorm

    # Others
    chromium
    tree
    htop
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
