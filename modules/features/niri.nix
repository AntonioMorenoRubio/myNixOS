{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, config, ... }: {
    options.myNiri.package = lib.mkOption {
      type = lib.types.package;
      default = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri-common;
    };

    config = {
      programs.niri = {
        enable = true;
        package = config.myNiri.package;
      };

      environment.variables.QS_ICON_THEME = "Papirus";
      environment.systemPackages = with pkgs; [ papirus-icon-theme ];
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri-common =
    let
      commonSettings = {
        spawn-at-startup = [ (lib.getExe self'.packages.myNoctalia) ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb.layout = "eu,es";
        input.touchpad = { tap = {}; dwt = {}; natural-scroll = {}; };
        layout.gaps = 5;
        binds = {
          # ── Teclado ───────────────────────────────────
          "Mod+Shift+Space".spawn-sh = "niri msg action switch-layout next";

          # ── Aplicaciones ──────────────────────────────
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh =
            "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

          # ── Ventanas ──────────────────────────────────
          "Mod+Q".close-window = {};
          "Mod+V".toggle-window-floating = {};
          #"Mod+Shift+V".toggle-focus-floating = {};

          # ── Foco (vim + flechas) ──────────────────────
          "Mod+H".focus-column-left = {};
          "Mod+L".focus-column-right = {};
          "Mod+J".focus-window-down = {};
          "Mod+K".focus-window-up = {};
          "Mod+Left".focus-column-left = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Down".focus-window-down = {};
          "Mod+Up".focus-window-up = {};

          # ── Mover columnas/ventanas ───────────────────
          "Mod+Ctrl+H".move-column-left = {};
          "Mod+Ctrl+L".move-column-right = {};
          "Mod+Ctrl+J".move-window-down = {};
          "Mod+Ctrl+K".move-window-up = {};

          # ── Workspaces ────────────────────────────────
          # U/I = PageDown/PageUp en tu capa nav (n/m)
          "Mod+U".focus-workspace-down = {};
          "Mod+I".focus-workspace-up = {};
          "Mod+Ctrl+U".move-column-to-workspace-down = {};
          "Mod+Ctrl+I".move-column-to-workspace-up = {};
          "Mod+Shift+U".move-workspace-down = {};
          "Mod+Shift+I".move-workspace-up = {};
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};

          # ── Tamaño de columnas ────────────────────────
          "Mod+R".switch-preset-column-width = {};
          "Mod+Shift+R".switch-preset-window-height = {};
          "Mod+Ctrl+R".reset-window-height = {};
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};
          "Mod+C".center-column = {};
          "Mod+KP_Subtract".set-column-width = "-10%";
          "Mod+KP_Add".set-column-width = "+10%";
          "Mod+Shift+KP_Subtract".set-window-height = "-10%";
          "Mod+Shift+KP_Add".set-window-height = "+10%";

          # ── Consume/expulsar ventanas ─────────────────
          "Mod+Comma".consume-window-into-column = {};
          "Mod+Period".expel-window-from-column = {};
          "Mod+Shift+Comma".consume-or-expel-window-left = {};
          "Mod+Shift+Period".consume-or-expel-window-right = {};

          # ── Capturas de pantalla ──────────────────────
          "Print".screenshot = {};
          "Alt+Print".screenshot-window = {};
          "Ctrl+Print".screenshot-screen = {};

          # ── Sistema ───────────────────────────────────
          "Mod+F1".show-hotkey-overlay = {};
          "Mod+Shift+E".quit = {};
        };
      };
    in
    inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = commonSettings;
    };

    packages.myNiri-desktop = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [ (lib.getExe self'.packages.myNoctalia) ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;
        input.keyboard.xkb.layout = "eu,es";
        layout.gaps = 5;
        binds = {
          # ── Teclado ───────────────────────────────────
          "Mod+Shift+Space".spawn-sh = "niri msg action switch-layout next";

          # ── Aplicaciones ──────────────────────────────
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh =
            "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

          # ── Ventanas ──────────────────────────────────
          "Mod+Q".close-window = {};
          "Mod+V".toggle-window-floating = {};
          #"Mod+Shift+V".toggle-focus-floating = {};

          # ── Foco (vim + flechas) ──────────────────────
          "Mod+H".focus-column-left = {};
          "Mod+L".focus-column-right = {};
          "Mod+J".focus-window-down = {};
          "Mod+K".focus-window-up = {};
          "Mod+Left".focus-column-left = {};
          "Mod+Right".focus-column-right = {};
          "Mod+Down".focus-window-down = {};
          "Mod+Up".focus-window-up = {};

          # ── Mover columnas/ventanas ───────────────────
          "Mod+Ctrl+H".move-column-left = {};
          "Mod+Ctrl+L".move-column-right = {};
          "Mod+Ctrl+J".move-window-down = {};
          "Mod+Ctrl+K".move-window-up = {};

          # ── Workspaces ────────────────────────────────
          # U/I = PageDown/PageUp en tu capa nav (n/m)
          "Mod+U".focus-workspace-down = {};
          "Mod+I".focus-workspace-up = {};
          "Mod+Ctrl+U".move-column-to-workspace-down = {};
          "Mod+Ctrl+I".move-column-to-workspace-up = {};
          "Mod+Shift+U".move-workspace-down = {};
          "Mod+Shift+I".move-workspace-up = {};
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = {};
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = {};

          # ── Tamaño de columnas ────────────────────────
          "Mod+R".switch-preset-column-width = {};
          "Mod+Shift+R".switch-preset-window-height = {};
          "Mod+Ctrl+R".reset-window-height = {};
          "Mod+F".maximize-column = {};
          "Mod+Shift+F".fullscreen-window = {};
          "Mod+C".center-column = {};
          "Mod+KP_Subtract".set-column-width = "-10%";
          "Mod+KP_Add".set-column-width = "+10%";
          "Mod+Shift+KP_Subtract".set-window-height = "-10%";
          "Mod+Shift+KP_Add".set-window-height = "+10%";

          # ── Consume/expulsar ventanas ─────────────────
          "Mod+Comma".consume-window-into-column = {};
          "Mod+Period".expel-window-from-column = {};
          "Mod+Shift+Comma".consume-or-expel-window-left = {};
          "Mod+Shift+Period".consume-or-expel-window-right = {};

          # ── Capturas de pantalla ──────────────────────
          "Print".screenshot = {};
          "Alt+Print".screenshot-window = {};
          "Ctrl+Print".screenshot-screen = {};

          # ── Sistema ───────────────────────────────────
          "Mod+F1".show-hotkey-overlay = {};
          "Mod+Shift+E".quit = {};
        };
        outputs."DVI-I-1" = {
          mode = "1920x1080@144.001";
        };
      };
    };

  };
}
