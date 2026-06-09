{ pkgs, ... }: {
  home.packages = with pkgs; [
    gcs
  ];
}
