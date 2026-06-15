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
    nodejs

    # CLI tools
    tree
    htop
    tmux
    rtk
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
