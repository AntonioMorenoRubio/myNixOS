{ pkgs, ... }: {
  home.packages = with pkgs; [
    git
    podman-compose
  ];

  programs.git = {
    enable = true;
  };
}
