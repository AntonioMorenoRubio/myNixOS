{ self, inputs, ... }: {
  flake.nixosModules.minecraft = { pkgs, ... }: {
    environment.systemPackages = with pkgs; [
        (prismlauncher.override {
            # Añadir programas extra al PATH (e.g., ffmpeg para mods de video)
            additionalPrograms = [
                ffmpeg
            ];
            # Añadir versiones adicionales de Java
            jdks = [
                zulu
            ];
        })
    ];
  };
}
