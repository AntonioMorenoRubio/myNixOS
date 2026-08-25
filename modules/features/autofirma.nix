{ self, inputs, ... }: {
  flake.nixosModules.autofirma = { pkgs, lib, config, ... }: {
    imports = [ inputs.autofirma-nix.nixosModules.default ];
    
    programs.autofirma = {
        enable = true;
        firefoxIntegration.enable = true;
    };

    # DNIeRemote integration for using phone as NFC reader
    programs.dnieremote = {
        enable = false;
    };
    # Note: The Android app may not be available on Google Play for modern devices.
    # See the troubleshooting guide for installation alternatives.

    # The FNMT certificate configurator
    programs.configuradorfnmt = {
        enable = true;
        firefoxIntegration.enable = true;
    };

    # Firefox configured to work with AutoFirma
    programs.firefox = {
        enable = true;
        policies.SecurityDevices = {
        "OpenSC PKCS#11" = "${pkgs.opensc}/lib/opensc-pkcs11.so";
        "DNIeRemote" = "${config.programs.dnieremote.finalPackage}/lib/libdnieremotepkcs11.so";
        };
    };

    # Enable PC/SC smart card service
    services.pcscd.enable = true;

    nix.settings = {
      extra-substituters = [ "https://nix-community.cachix.org" ];
      trusted-public-keys = [ "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs=" ];
    };
  };
}
