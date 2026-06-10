{ pkgs, ... }: {
  home.packages = with pkgs; [
    # DevOps
    git
    gh
    podman
    podman-tui
    podman-compose

    # SDKs
    dotnet-sdk_10

    # CLI tools
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
}
