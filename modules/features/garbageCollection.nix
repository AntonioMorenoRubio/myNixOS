{ self, inputs, ... }: {
  flake.nixosModules.garbageCollection = { config, lib, ... }: {
    boot.loader.systemd-boot.configurationLimit = 3;
    nix.gc = {
        automatic = true;
        dates = "weekly";
        options = "--delete-older-than 7d";
        };

    nix.optimise.automatic = true;
    nix.optimise.dates = [ "20:00" ];

    nix.extraOptions = ''
        min-free = ${toString (100 * 1024 * 1024)}
        max-free = ${toString (1024 * 1024 * 1024)}
    '';
  };
}
