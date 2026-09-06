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

    (pkgs.writeShellScriptBin "cc3-set-dpi" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      wineserver -k || true
      wine reg add "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d "$1" /f
      wineserver -w
      echo "DPI de CC3+ puesto a $1 (96=100%, 120=125%, 144=150%, 168=175%)"
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

        (pkgs.writeShellScriptBin "profantasy-install-all" ''
      export WINEPREFIX=${winePrefix}
      export PATH="${wine}/bin:$PATH"
      set -e
      installers=(
        "BattleMap and FloorMap Collection/BMFC_Setup.exe"
        "Campaign Cartographer 3/CC3PlusRandomDungeon.exe"
        "Campaign Cartographer 3/MonthlyContent2023.exe"
        "Campaign Cartographer 3/MonthlyContent2024.exe"
        "Campaign Cartographer 3/MonthlyContent2025.exe"
        "Campaign Cartographer 3/MonthlyContent2026.exe"
        "Cartographer's Annual/01 (2007)/CA2007_SetupForCC3Plus.exe"
        "Cartographer's Annual/02 (2008)/CA2008_SetupForCC3Plus.exe"
        "Cartographer's Annual/03 (2009)/CA2009_SetupForCC3Plus.exe"
        "Cartographer's Annual/04 (2010)/CA2010_SetupForCC3Plus.exe"
        "Cartographer's Annual/05 (2011)/CA2011_SetupForCC3Plus.exe"
        "Cartographer's Annual/06 (2012)/CA2012_SetupForCC3Plus.exe"
        "Cartographer's Annual/07 (2013)/CA2013_SetupForCC3Plus.exe"
        "Cartographer's Annual/08 (2014)/CA2014_SetupForCC3Plus.exe"
        "Cartographer's Annual/09 (2015)/CA2015_SetupForCC3Plus.exe"
        "Cartographer's Annual/10 (2016)/CA2016_Setup.exe"
        "Cartographer's Annual/11 (2017)/CA2017_Setup.exe"
        "Cartographer's Annual/12 (2018)/CA2018_Setup.exe"
        "Cartographer's Annual/14 (2020)/CA2020_Setup.exe"
        "Cartographer's Annual/15 (2021)/CA2021_Setup.exe"
        "Cartographer's Annual/16 (2022)/CA2022_Setup.exe"
        "Cartographer's Collection/HC4_Setup/HC4_Setup.exe"
        "Cartographer's Collection/HCC1_Setup.exe"
        "Character Artist 3/CA3SetupForCC3Plus.exe"
        "City Designer 3/CD3SetupForCC3Plus.exe"
        "City Designer 3/RandomCity_CC3Plus.exe"
        "City Designer 3/ScottsCelticBuildings.exe"
        "Cosmographer 3/COS3SetupForCC3Plus.exe"
        "Dioramas 3/DIO3Setup.exe"
        "Dungeon Designer 3/DD3SetupForCC3Plus.exe"
        "Dungeon Designer 3/ShessarsFireplaces_CC3Plus.exe"
        "Perspectives 3/PER3Setup.exe"
        "Source Maps/SMCastlesSetupForCC3Plus.exe"
        "Source Maps/SMCitiesSetupForCC3Plus.exe"
        "Source Maps/SMTemplesSetupForCC3Plus.exe"
        "Symbol Sets/SS1SetupForCC3Plus.exe"
        "Symbol Sets/SS2SetupForCC3Plus.exe"
        "Symbol Sets/SS3SetupForCC3Plus.exe"
        "Symbol Sets/SS4SetupForCC3Plus.exe"
        "Symbol Sets/SS5Setup.exe"
        "Symbol Sets/SS6Setup.exe"
        "Token Treasury/TTMonsters1Setup.exe"
        "Token Treasury/TTMonsters2Setup.exe"
        "Tome of Ultimate Mapping v3 Plus/TUM3Plus_Setup.exe"
        "World Builder's Compendium/HWBC_Setup.exe"
        "World War II Interactive Atlas/WW2IASetupForCC3Plus.exe"
      )
      total=''${#installers[@]}
      i=1
      for rel in "''${installers[@]}"; do
        echo ""
        echo "=== [$i/$total] $rel ==="
        wine "${installersRoot}/$rel"
        echo "--- Terminado. Enter para seguir con el siguiente, Ctrl+C para parar aquí. ---"
        read -r
        i=$((i+1))
      done
      echo "Listo — se han lanzado los $total instaladores."
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

    (pkgs.writeShellScriptBin "ft3-set-dpi" ''
      export WINEPREFIX=${ft3Prefix}
      export PATH="${wineWow}/bin:$PATH"
      wineserver -k || true
      wine reg add "HKCU\Control Panel\Desktop" /v LogPixels /t REG_DWORD /d "$1" /f
      wineserver -w
      echo "DPI de FT3+ puesto a $1 (96=100%, 120=125%, 144=150%, 168=175%)"
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