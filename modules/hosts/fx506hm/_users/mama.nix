{ self, pkgs, ... }: {
    imports = [
        "${self}/modules/features/_home/base.nix"
    ];
    home = {
        username = "mama";
        homeDirectory = "/home/mama";
        stateVersion = "25.11";
    };
}
