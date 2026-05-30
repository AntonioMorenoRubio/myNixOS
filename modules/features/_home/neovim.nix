{ inputs, pkgs, ... }:
{
  imports = [ inputs.nvim-config.homeManagerModules.default ];
}