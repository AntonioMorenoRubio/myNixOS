{ self, inputs, ... }: {
  flake.nixosModules.games = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      lutris-free
    ];
  };
}
