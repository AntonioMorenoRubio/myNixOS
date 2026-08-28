{ self, inputs, ... }: {
  flake.nixosModules.multimedia = { pkgs, lib, config, ... }: {
    environment.systemPackages = with pkgs; [
        vlc
    ];
  };
}
