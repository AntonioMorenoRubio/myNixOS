{ self, inputs, ... }:
let
  system = "x86_64-linux";
  pkgs-unstable = import inputs.unstable {
    inherit system;
    config.allowUnfree = true;
  };
in {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    inherit system;
    modules = [
      self.nixosModules.desktop_Configuration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit self inputs pkgs-unstable; };
          users.antonio = import ./_users/antonio.nix;
          users.mama = import ./_users/mama.nix;
        };
      }
    ];
  };
}