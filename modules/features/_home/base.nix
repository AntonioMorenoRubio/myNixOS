{ pkgs, ... }: {
  home.packages = with pkgs; [
    thunderbird
    kdePackages.kate
    obsidian
  ];
}
