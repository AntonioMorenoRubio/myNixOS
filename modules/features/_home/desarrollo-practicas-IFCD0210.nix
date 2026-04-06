{ pkgs, ... }: {
  home.packages = with pkgs; [
    # DevOps
    git
    gh
    podman
    podman-desktop
    podman-tui
    podman-compose

    # Desarrollo
    jetbrains.idea-oss
    jetbrains.webstorm
    android-studio-full
    android-studio-tools
  ];

  programs.git = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };

  programs.vscode = {
    enable = true;
    defaultEditor = true;
  };
}
