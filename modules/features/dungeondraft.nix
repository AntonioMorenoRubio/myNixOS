{ self, ... }: {
  flake.nixosModules.dungeondraft = { pkgs, lib, ... }:
    let
      dungeondraft = pkgs.stdenv.mkDerivation rec {
        pname = "dungeondraft";
        version = "1.2.0.1";

        src = pkgs.requireFile {
          name = "Dungeondraft-${version}-Linux64.deb";
          url = "https://www.dungeondraft.net/";
          hash = "sha256-UvvUCQ1RkhwBPMet/zD0JjI7DPbF4ixzOX85Fi3v/BE=";
        };

        nativeBuildInputs = [ pkgs.dpkg ];
        dontConfigure = true;
        dontBuild = true;

        installPhase = ''
          runHook preInstall
          mkdir -p $out/bin
          cp -R usr/share opt $out/
          substituteInPlace \
            $out/share/applications/Dungeondraft.desktop \
            --replace /opt/ $out/opt/
          ln -s $out/opt/Dungeondraft/Dungeondraft.x86_64 $out/bin/Dungeondraft.x86_64
          runHook postInstall
        '';

        preFixup =
          let
            libPath = lib.makeLibraryPath (with pkgs; [
              libxcursor libxinerama libxrandr libx11 libxi libGL alsa-lib pulseaudio
            ]);
          in
          ''
            patchelf \
              --set-interpreter "$(cat ${pkgs.stdenv.cc}/nix-support/dynamic-linker)" \
              --set-rpath "${libPath}" \
              $out/opt/Dungeondraft/Dungeondraft.x86_64
          '';

        meta = {
          homepage = "https://www.dungeondraft.net/";
          description = "Mapmaking tool for dungeon, building, and interior maps for tabletop RPGs";
          license = lib.licenses.unfree;
          platforms = [ "x86_64-linux" ];
          sourceProvenance = with lib.sourceTypes; [ pkgs.lib.sourceTypes.binaryNativeCode ];
        };
      };
    in
    {
      environment.systemPackages = [ dungeondraft ];
    };
}