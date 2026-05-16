{ self, inputs, ... }:
{
  flake.nixosModules.communications = { pkgs, lib, ... }: {
    environment.systemPackages = with pkgs; [
        zapzap
        telegram-desktop
        discord
        (discordo.override { buildGoModule = inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.buildGoModule; })
    ];
  };
}