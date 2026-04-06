{ pkgs, ... }: {
  home.packages = with pkgs; [
    floorp-bin
    thunderbird
    kdePackages.kate
    obsidian
    bitwarden-desktop
    bitwarden-cli
  ];
}
