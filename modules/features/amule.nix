{ self, inputs, ... }: {
  flake.nixosModules.amule = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.amule
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.amule-gui
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.amule-web
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.amule-daemon
    ];
  };
}
