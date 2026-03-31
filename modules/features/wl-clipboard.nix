{ self, inputs, ... }: {
  flake.nixosModules.wlClipboard = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];
  };
}
