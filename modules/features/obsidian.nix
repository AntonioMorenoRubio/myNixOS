{ self, inputs, ... }: {
  flake.nixosModules.obsidian = { pkgs, lib, ... }: {
    nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
        inputs.unstable.legacyPackages.${pkgs.stdenv.hostPlatform.system}.obsidian
    ];

    nixpkgs.config.permittedInsecurePackages = [
        "electron-39.8.10"
    ];
  };
}