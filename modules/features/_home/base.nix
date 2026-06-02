{ pkgs, ... }: {
  home.packages = with pkgs; [
    floorp-bin
    thunderbird
    kdePackages.kate
    bitwarden-desktop
    bitwarden-cli
  ];
}
