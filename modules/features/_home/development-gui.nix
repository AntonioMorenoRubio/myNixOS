{ pkgs, ... }: {
  home.packages = with pkgs; [
    # IDEs
    jetbrains.rider
    jetbrains.idea-oss
    jetbrains.webstorm

    # Browsers for Web Development
    chromium
  ];

  programs.vscode.enable = true;
}