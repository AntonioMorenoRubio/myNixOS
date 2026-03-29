{ self, inputs, ... }: {

flake.nixosConfigurations.fx506hm = inputs.nixpkgs.lib.nixosSystem {
	modules = [
		self.nixosModules.fx506hm_Configuration
	];
};
}
