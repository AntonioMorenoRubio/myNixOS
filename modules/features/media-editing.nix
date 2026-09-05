{ self, inputs, ... }: {
  flake.nixosModules.media-editing = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.kdePackages.kdenlive
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.obs-studio
    ];
  };
}