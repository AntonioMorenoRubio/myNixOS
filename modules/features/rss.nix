{ self, inputs, ... }: {
  flake.nixosModules.rss = { pkgs, lib, config, ... }: {
    environment.systemPackages = with pkgs; [
        rssguard
    ];
  };
}
