{ self, inputs, ... }: {
  flake.nixosConfigurations.wsl-nixos = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.wsl-nixos_Configuration
      inputs.home-manager.nixosModules.home-manager
      {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = { inherit self inputs; };
          users.antonio = import ./_users/antonio.nix;
        };
      }
    ];
  };
}
