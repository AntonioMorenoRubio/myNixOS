{ self, inputs, ... }: {
    flake.nixosModules.flatpak = { pkgs, ... } : {
        services.flatpak = {
            enable = true;
            package = pkgs.flatpak;
        };
        xdg.portal = {
            enable = true;
            extraPortals = [
                pkgs.kdePackages.xdg-desktop-portal-kde
                pkgs.xdg-desktop-portal-gtk
            ];
        };
    };
}