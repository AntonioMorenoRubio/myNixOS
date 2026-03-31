{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    podman-compose
  ];

  programs.git = {
    enable = true;
  };

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
  };
}
