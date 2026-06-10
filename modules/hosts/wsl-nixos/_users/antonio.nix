{ self, pkgs, config, ... }: {
    imports = [
        "${self}/modules/features/_home/base.nix"
        "${self}/modules/features/_home/development-cli.nix"
        "${self}/modules/features/_home/development-gui.nix"
        #"${self}/modules/features/_home/neovim.nix"
        "${self}/modules/features/_home/fish.nix"
        "${self}/modules/features/_home/starship.nix"
        "${self}/modules/features/_home/kitty.nix"
    ];
    
    home = {
        username = "antonio";
        homeDirectory = "/home/antonio";
        file."Projects".source = config.lib.file.mkOutOfStoreSymlink "/mnt/f:/Projects";
        stateVersion = "26.05";
    };

    programs.git.settings.user = {
        name = "AntonioMorenoRubio";
        email = "amrinformatica10@gmail.com";
    };

    xdg.userDirs = {
      enable = true;
      setSessionVariables = true;
      createDirectories = false;
      desktop     = "${config.home.homeDirectory}/Escritorio";
      download    = "${config.home.homeDirectory}/Descargas";
      templates   = "${config.home.homeDirectory}/Plantillas";
      publicShare = "${config.home.homeDirectory}/Público";
      documents   = "${config.home.homeDirectory}/Documentos";
      music       = "${config.home.homeDirectory}/Música";
      pictures    = "${config.home.homeDirectory}/Imágenes";
      videos      = "${config.home.homeDirectory}/Vídeos";
      projects    = "/mnt/f:/Projects";
    };
}
