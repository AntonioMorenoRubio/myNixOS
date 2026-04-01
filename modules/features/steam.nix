{ self, inputs, ... }: {
  flake.nixosModules.steam = { pkgs, ... }: {
    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      gamescopeSession.enable = true;
    };

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };

    programs.gamemode.enable = true;

    environment.systemPackages = with pkgs; [
      protonup-qt
    ];
  };
}
