{ self, inputs, ... }:

let
  version      = "latest";
  payloadBytes = 106063477;
  totalDataLen = 110698416;
  mainClass    = "install4j.Installer3118837495";

  tws-extracted = pkgs: pkgs.stdenv.mkDerivation {
    pname = "tws-extracted";
    inherit version;

    src = pkgs.fetchurl {
      url  = "https://download2.interactivebrokers.com/installers/tws/latest/tws-latest-linux-x64.sh";
      hash = "sha256-JEQmQ6wCjqD8X4Q5zOUX+X/DmHIHL1Zz1Wwr2cNq7rU=";
    };

    dontUnpack    = true;
    dontConfigure = true;
    dontBuild     = true;

    nativeBuildInputs = with pkgs; [ coreutils gnutar gzip ];

    installPhase = ''
      runHook preInstall
      mkdir -p $out/share/tws
      cd $out/share/tws

      # El instalador busca sus .dat dentro de este .sh, hay que conservarlo
      cp "$src" ./tws-installer.sh
      chmod +x ./tws-installer.sh

      tail -c ${toString payloadBytes} "$src" > payload.tar.gz
      gunzip payload.tar.gz
      tar xf payload.tar
      rm -f payload.tar

      if [ -f jre.tar.gz ]; then
        gunzip jre.tar.gz
        mkdir -p jre
        ( cd jre && tar xf ../jre.tar )
        rm -f jre.tar
      fi

      if [ -x ./jre/bin/unpack200 ]; then
        for f in *.jar.pack user/*.jar.pack user/*.zip.pack; do
          [ -f "$f" ] || continue
          ./jre/bin/unpack200 -q -r "$f" "''${f%.pack}" || true
        done
      fi

      chmod -R u+w .
      runHook postInstall
    '';
  };

  # Chromium no está en TWS, pero glib y otros aún invocan cosas; el shim de udev
  # es barato y evita sorpresas con librerías legacy que pidan .so.0
  libudev-shim = pkgs: pkgs.runCommand "libudev-shim" { } ''
    mkdir -p $out/lib
    ln -s ${pkgs.udev}/lib/libudev.so.1 $out/lib/libudev.so.0
  '';

  fhsLibs = p: with p; [
    # Base
    zlib zstd bzip2 expat
    stdenv.cc.cc.lib
    glib dbus
    krb5
    openssl

    # X11 / AWT
    libX11 libXext libXrender libXtst libXi libXfixes libXcursor
    libXrandr libXcomposite libXdamage libXt
    libxcb
    libxcb-util
    libxcb-wm
    libxcb-image
    libxcb-keysyms
    libxcb-render-util
    libxcb-cursor
    libxkbcommon

    # GPU / DRM (para Java2D acelerado o fallback software)
    libglvnd libdrm libgbm mesa

    # Fuentes
    fontconfig freetype
    dejavu_fonts
    liberation_ttf

    # Audio
    alsa-lib pulseaudio

    # TLS / NSS / impresión
    nss nspr cups

    # Iconos
    adwaita-icon-theme
    hicolor-icon-theme

    # Utilidades que algunos wrappers invocan
    coreutils
    bash
    which
  ];

  tws-installer = pkgs:
    let
      extracted = tws-extracted pkgs;
      launch = pkgs.writeShellScript "tws-install" ''
        APP=${extracted}/share/tws
        cd "$APP"
        exec "$APP/jre/bin/java" \
          -Dexe4j.moduleName="$APP/tws-installer.sh" \
          -Dexe4j.totalDataLength=${toString totalDataLen} \
          -Dinstall4j.cwd="$HOME" \
          --add-opens java.desktop/java.awt=ALL-UNNAMED \
          -Dinstall4j.debugLaunch=true \
          -classpath "i4jruntime.jar:launcher0.jar" \
          ${mainClass} "$@"
      '';
    in
    pkgs.buildFHSEnv {
      name = "tws";
      targetPkgs = p: (fhsLibs p) ++ (with p; [ udev ]) ++ [ (libudev-shim p) ];
      runScript = "${launch}";
    };

  tws-desktop = pkgs:
    let
      extracted = tws-extracted pkgs;
      jreHome   = "${extracted}/share/tws/jre";
      launch = pkgs.writeShellScript "tws-launch" ''
        export INSTALL4J_JAVA_HOME=${jreHome}
        export QT_QPA_PLATFORM=xcb
        export GDK_BACKEND=x11
        exec "$HOME/Jts/tws" \
          -J-DjtsConfigDir="$HOME/Jts" \
          -J-Dsun.java2d.uiScale=1.0 \
          "$@"
      '';
    in
    pkgs.buildFHSEnv {
      name = "tws-desktop";
      targetPkgs = p: (fhsLibs p) ++ (with p; [ udev ]) ++ [ (libudev-shim p) ];
      runScript = "${launch}";
    };

in
{
  perSystem = { pkgs, system, ... }: {
    packages = inputs.nixpkgs.lib.optionalAttrs (system == "x86_64-linux") {
      tws         = tws-installer pkgs;
      tws-desktop = tws-desktop pkgs;
    };
  };

  flake.nixosModules.ibkr = { pkgs, ... }: {
    environment.systemPackages = [
      self.packages.${pkgs.stdenv.hostPlatform.system}.tws
      self.packages.${pkgs.stdenv.hostPlatform.system}.tws-desktop
    ];
  };
}
