{ self, inputs, ... }: {
  flake.nixosModules.android = { pkgs, lib, config, ... }: {
    environment.systemPackages = with pkgs; [
        android-tools
    ];
  };
}
