{ self, inputs, ... }: {
  flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.desktop_Configuration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit self; };
          users.antonio = import ./_users/antonio.nix;
          users.mama = import ./_users/mama.nix;
        };
      }
    ];
  };
}
