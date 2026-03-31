{ self, inputs, ... }: {
  flake.nixosModules.podman = { pkgs, ... }: {
    virtualisation.podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
