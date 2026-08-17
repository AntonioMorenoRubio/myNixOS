{ self, inputs, ... }: {
  flake.nixosModules.wonderdraft = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        wonderdraft
    ];
  };
}
