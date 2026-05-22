{ self, inputs, ... }: {
  flake.nixosModules.vial = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
      vial
    ];
    services.udev.packages = with pkgs; [
      qmk-udev-rules
      vial
    ];

    hardware.keyboard.qmk.enable = true;
  };
}
