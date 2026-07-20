{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-26.05";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    flake-parts.url = "github:hercules-ci/flake-parts";
    import-tree.url = "github:vic/import-tree";

    wrapper-modules.url = "github:BirdeeHub/nix-wrapper-modules";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    aagl = {
      url = "github:ezKEa/aagl-gtk-on-nix/release-26.05"; # o sigue "main" para unstable
      inputs.nixpkgs.follows = "nixpkgs";
    };

    reliquary-archiver-nix-module = {
      url = "git+https://github.com/daanturo/reliquary-archiver-nix-module.git";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    autofirma-nix = {
      url = "github:nix-community/autofirma-nix";  # For nixpkgs-unstable
      # url = "github:nix-community/autofirma-nix/release-25.05";  # For NixOS 25.05
      inputs.nixpkgs.follows = "unstable";
    };

    # nvim-config = {
    #   url = "github:AntonioMorenoRubio/nvim-config";
    #   inputs.nixpkgs.follows = "nixpkgs";
    # };
  };

  outputs = inputs: inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules);
}
