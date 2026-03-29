{ self, inputs, ... }: {

flake.nixosConfigurations.desktop = inputs.nixpkgs.lib.nixosSystem {
	modules = [
		self.nixosModules.desktop_Configuration
	];
};
}
