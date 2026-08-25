{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Containerization
    podman-desktop

    # IDEs
    jetbrains.rider
    jetbrains.idea
    jetbrains.webstorm

    # Browsers for Web Development
    chromium
  ];

  programs.vscode.enable = true;
}
