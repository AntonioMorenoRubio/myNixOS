{ self, pkgs, ... }: {
  home.packages = with pkgs; [
    self.inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.gcs
  ];
}
