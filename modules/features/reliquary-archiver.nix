{ self, inputs, ... }:
{
  flake.nixosModules.reliquaryArchiver = { pkgs, lib, config, ... }:
    let
      binarySource = self + "/bin/reliquary-archiver";
      # Empacar el binario en el store (sin setcap, porque lo hará el servicio)
      reliquary-archiver = pkgs.runCommand "reliquary-archiver-prebuilt" {} ''
        mkdir -p $out/bin
        cp ${binarySource} $out/bin/reliquary-archiver
        chmod +x $out/bin/reliquary-archiver
      '';
    in
    {
      options.services.reliquary-archiver = {
        enable = lib.mkEnableOption "reliquary-archiver system service";
        websocketPort = lib.mkOption {
          type = lib.types.port;
          default = 23313;
        };
      };

      config = let
        cfg = config.services.reliquary-archiver;
      in lib.mkIf cfg.enable {
        # Script de lanzamiento combinado (para el usuario)
        environment.systemPackages = with pkgs; [
          libpcap
          (writeShellScriptBin "hsr-with-archiver" ''
            if ! systemctl is-active --quiet reliquary-archiver; then
              echo "Iniciando reliquary-archiver (servicio de sistema)..."
              sudo systemctl start reliquary-archiver
              sleep 2
            else
              echo "reliquary-archiver ya está activo."
            fi
            echo "Lanzando Honkers Railway Launcher..."
            exec honkers-railway-launcher
          '')
        ];

        # Servicio del sistema (global)
        systemd.services.reliquary-archiver = {
          description = "Reliquary Archiver for HSR (system service)";
          after = [ "network.target" ];
          wantedBy = [ "multi-user.target" ];
          serviceConfig = {
            ExecStart = "${reliquary-archiver}/bin/reliquary-archiver --stream --websocket-port ${toString cfg.websocketPort}";
            Restart = "on-failure";
            RestartSec = 5;
            User = "antonio";  # Ejecuta como tu usuario
            AmbientCapabilities = [ "CAP_NET_RAW" ];
            NoNewPrivileges = false;
          };
        };
      };
    };
}