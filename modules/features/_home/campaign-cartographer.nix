{ pkgs, ... }:
let
  wine = pkgs.wine;                          # 32-bit puro, para CC3+ y su suite
  wineWow = pkgs.wineWow64Packages.stable;   # con WOW64, solo para FT3+
  winetricks = pkgs.winetricks;
  installersRoot = "/mnt/PERSONAL/Juegos-Rol-Apps/Campaign Cartographer Installers";
  winePrefix = "$HOME/.local/share/wineprefixes/profantasy";
  ft3Prefix = "$HOME/.local/share/wineprefixes/profantasy-ft3";
in
{
  home.packages = [

    # --- suite CC3+ (32-bit puro) ---
    (pkgs.writeShellScriptBin "profantasy-init" ''
      set -e
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:${winetricks}/bin:$PATH"
      mkdir -p "$WINEPREFIX"
      wineboot --init
      wineserver -w
      winetricks -q corefonts
      wineserver -w
      wine reg add "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 144 /f
      echo "Prefix listo en $WINEPREFIX"
    '')

    (pkgs.writeShellScriptBin "profantasy-set-dpi" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      wineserver -k || true
      wine reg add "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d "$1" /f
      wineserver -w
      echo "DPI puesto a $1 (96=100%, 120=125%, 144=150%, 168=175%)"
    '')

    (pkgs.writeShellScriptBin "profantasy-fonts-fallback" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      mkdir -p "$WINEPREFIX/drive_c/windows/Fonts"
      cp ${pkgs.liberation_ttf}/share/fonts/truetype/*.ttf "$WINEPREFIX/drive_c/windows/Fonts/"
      cp ${pkgs.carlito}/share/fonts/truetype/*.ttf "$WINEPREFIX/drive_c/windows/Fonts/"
      wine reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "Arial" /d "Liberation Sans" /f
      wine reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "Times New Roman" /d "Liberation Serif" /f
      wine reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "Courier New" /d "Liberation Mono" /f
      wine reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "MS Sans Serif" /d "Liberation Sans" /f
      wine reg add "HKLM\Software\Microsoft\Windows NT\CurrentVersion\FontSubstitutes" /v "Calibri" /d "Carlito" /f
      wineserver -w
    '')

    (pkgs.writeShellScriptBin "profantasy-install-cc3" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      wine "${installersRoot}/Campaign Cartographer 3/CC3PlusSetup398.exe"
      wine "${installersRoot}/Campaign Cartographer 3/CC3PlusUpdate28.exe"
    '')

    (pkgs.writeShellScriptBin "profantasy-install-addon" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      wine "${installersRoot}/$1"
    '')

    (pkgs.writeShellScriptBin "profantasy-list-installers" ''
      find "${installersRoot}" -iname "*.exe" | sed "s|${installersRoot}/||"
    '')

    (pkgs.writeShellScriptBin "profantasy-find-exes" ''
      find "${winePrefix}/drive_c/Program Files" "${winePrefix}/drive_c/Program Files (x86)" -iname "*.exe" 2>/dev/null
    '')

    (pkgs.writeShellScriptBin "cc3-launch" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      wine "$WINEPREFIX/drive_c/Program Files/ProFantasy/CC3Plus/fcw32.exe"
    '')

    # --- Fractal Terrains 3+ (prefix separado, con WOW64) ---
    (pkgs.writeShellScriptBin "ft3-init" ''
      set -e
      export WINEPREFIX=${ft3Prefix}
      export PATH="${wineWow}/bin:${winetricks}/bin:$PATH"
      mkdir -p "$WINEPREFIX"
      wineboot --init
      wineserver -w
      winetricks -q corefonts
      wineserver -w
      wine reg add "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d 144 /f
      echo "Prefix de FT3+ listo en $WINEPREFIX"
    '')

    (pkgs.writeShellScriptBin "profantasy-install-ft3" ''
      export WINEPREFIX=${ft3Prefix}
      export PATH="${wineWow}/bin:$PATH"
      wine "${installersRoot}/Fractal Terrains 3/FT3Setup3Plus.exe"
    '')

    (pkgs.writeShellScriptBin "ft3-find-exes" ''
      find "${ft3Prefix}/drive_c/Program Files" "${ft3Prefix}/drive_c/Program Files (x86)" -iname "*.exe" 2>/dev/null
    '')

    (pkgs.writeShellScriptBin "ft3-launch" ''
      export WINEPREFIX=${ft3Prefix}
      export PATH="${wineWow}/bin:$PATH"
      wine "$WINEPREFIX/drive_c/Program Files (x86)/ProFantasy/FT3.5/FT.exe"
    '')
  ];
}