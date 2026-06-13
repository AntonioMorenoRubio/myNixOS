{ self, inputs, ... }: {
  flake.nixosModules.remoteDesktop = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        kdePackages.krdc
    ];
  };
}
