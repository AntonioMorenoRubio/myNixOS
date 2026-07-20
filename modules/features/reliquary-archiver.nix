{ self, inputs, ... }:
{
  flake.nixosModules.reliquaryArchiver = { pkgs, lib, ... }: {
    imports = [ inputs.reliquary-archiver-nix-module.nixosModules.default ];
  };
}