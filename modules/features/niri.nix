{ self, inputs, ... }: {
  flake.nixosModules.niri = { pkgs, lib, ... }: {
    programs.niri = {
      enable = true;
      package = self.packages.${pkgs.stdenv.hostPlatform.system}.myNiri;
    };
  };

  perSystem = { pkgs, lib, self', ... }: {
    packages.myNiri = inputs.wrapper-modules.wrappers.niri.wrap {
      inherit pkgs;
      settings = {
        spawn-at-startup = [
          (lib.getExe self'.packages.myNoctalia)
        ];
        xwayland-satellite.path = lib.getExe pkgs.xwayland-satellite;

        input = {
          keyboard.xkb = {
            layout = "es,us";
            variant = "";
          };
          touchpad = {
            tap = {};
            dwt = {};
            natural-scroll = {};
          };
        };

        layout.gaps = 5;

        binds = {
          # ── Aplicaciones ──────────────────────────────
          "Mod+Return".spawn-sh = lib.getExe pkgs.kitty;
          "Mod+S".spawn-sh =
            "${lib.getExe self'.packages.myNoctalia} ipc call launcher toggle";

          # ── Ventanas ──────────────────────────────────
          "Mod+Q".close-window = null;
          "Mod+V".toggle-window-floating = null;
          #"Mod+Shift+V".toggle-focus-floating = null;

          # ── Foco (vim + flechas) ──────────────────────
          "Mod+H".focus-column-left = null;
          "Mod+L".focus-column-right = null;
          "Mod+J".focus-window-down = null;
          "Mod+K".focus-window-up = null;
          "Mod+Left".focus-column-left = null;
          "Mod+Right".focus-column-right = null;
          "Mod+Down".focus-window-down = null;
          "Mod+Up".focus-window-up = null;

          # ── Mover columnas/ventanas ───────────────────
          "Mod+Ctrl+H".move-column-left = null;
          "Mod+Ctrl+L".move-column-right = null;
          "Mod+Ctrl+J".move-window-down = null;
          "Mod+Ctrl+K".move-window-up = null;

          # ── Workspaces ────────────────────────────────
          # U/I = PageDown/PageUp en tu capa nav (n/m)
          "Mod+U".focus-workspace-down = null;
          "Mod+I".focus-workspace-up = null;
          "Mod+Ctrl+U".move-column-to-workspace-down = null;
          "Mod+Ctrl+I".move-column-to-workspace-up = null;
          "Mod+Shift+U".move-workspace-down = null;
          "Mod+Shift+I".move-workspace-up = null;
          "Mod+Ctrl+Page_Down".move-column-to-workspace-down = null;
          "Mod+Ctrl+Page_Up".move-column-to-workspace-up = null;

          # ── Tamaño de columnas ────────────────────────
          "Mod+R".switch-preset-column-width = null;
          "Mod+Shift+R".switch-preset-window-height = null;
          "Mod+Ctrl+R".reset-window-height = null;
          "Mod+F".maximize-column = null;
          "Mod+Shift+F".fullscreen-window = null;
          "Mod+C".center-column = null;
          "Mod+Minus".set-column-width = "-10%";
          "Mod+Plus".set-column-width = "+10%";
          "Mod+Shift+Minus".set-window-height = "-10%";
          "Mod+Shift+Plus".set-window-height = "+10%";

          # ── Consume/expulsar ventanas ─────────────────
          "Mod+Comma".consume-window-into-column = null;
          "Mod+Period".expel-window-from-column = null;

          # ── Capturas de pantalla ──────────────────────
          "Print".screenshot = null;
          "Alt+Print".screenshot-window = null;
          "Ctrl+Print".screenshot-screen = null;

          # ── Sistema ───────────────────────────────────
          "Mod+F1".show-hotkey-overlay = null;
          "Mod+Shift+E".quit = null;
        };
      };
    };
  };
}
