{ self, pkgs, ... }: {
  home.packages = with pkgs; [
    (stdenv.mkDerivation rec {
    pname = "gcs";
    version = "5.54.1";
    author = "richardwilkes";

    # Descargamos el ejecutable precompilado oficial de Linux
    src = fetchurl {
      url = "https://github.com/${author}/${pname}/releases/download/v${version}/${pname}-${version}-linux-amd64.tgz";
      hash = "sha256-Xaczw4Kq8/+Nuj70mYGpK29hSpJPvkSNVplQeMlEZSU=";
    };

    sourceRoot = ".";

    # Herramientas necesarias para que NixOS adapte el binario externo
    nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
    
    # Librerías del sistema que GCS necesita para abrir su interfaz gráfica
    buildInputs = [ glib gtk3 cairo pango atk gdk-pixbuf zlib xorg.libX11 ];

    # Evitamos que Nix intente compilar nada, solo descomprimir
    dontBuild = true;

    installPhase = ''
      mkdir -p $out/bin
      # Copiamos el binario a la ruta final
      cp gcs $out/bin/
      chmod +x $out/bin/gcs
    '';
  })
  ];
}
