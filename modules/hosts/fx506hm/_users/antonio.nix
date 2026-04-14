{ self, pkgs, ... }: {
    imports = [
        "${self}/modules/features/_home/base.nix"
        "${self}/modules/features/_home/development.nix"
        "${self}/modules/features/_home/fish.nix"
        "${self}/modules/features/_home/starship.nix"
        "${self}/modules/features/_home/kitty.nix"
        "${self}/modules/features/_home/android.nix"
    ];
    home = {
        username = "antonio";
        homeDirectory = "/home/antonio";
        stateVersion = "25.11";
    };

    programs.git.settings.user = {
        name = "AntonioMorenoRubio";
        email = "amrinformatica10@gmail.com";
    };
}
