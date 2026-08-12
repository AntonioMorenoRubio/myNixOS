{ self, inputs, ... }:
{
  flake.nixosModules.foundryvtt = { pkgs, lib, ... }: {
    imports = [ inputs.foundryvtt.nixosModules.foundryvtt ];

    services.foundryvtt = {
      enable = true;
      hostName = "foundry.myhostname.com";
      minifyStaticFiles = true;
      package = inputs.foundryvtt.packages.${pkgs.stdenv.hostPlatform.system}.foundryvtt_14.overrideAttrs {
        version = "14.0.0+364";
        src = "/nix/store/apfarcfjscp58pmnb20lisqzamdr7a2g-FoundryVTT-Linux-14.364.zip";
      };
      proxySSL = true;
      proxyPort = 443;
    };
  };
}