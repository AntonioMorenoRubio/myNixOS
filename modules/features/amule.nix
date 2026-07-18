{ self, inputs, ... }: {
  flake.nixosModules.amule = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        amule
        amule-gui
        amule-web
        amule-daemon
    ];
  };
}
