{ self, inputs, ... }: {
  flake.nixosModules.devenv = { pkgs, lib, ... }: {
    environment.systemPackages = [
      inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.devenv
    ];
  };
}
