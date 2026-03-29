{ self, inputs, ... }: {

  perSystem = { pkgs, system, ... }: 
    let
      # Definimos pkgsUnstable antes de abrir el set de atributos final
      pkgsUnstable = import inputs.unstable {
        inherit system;
        config.allowUnfree = true;
      };
    in
    {
      packages.myNoctalia = inputs.wrapper-modules.wrappers.noctalia-shell.wrap {
        # Ahora sí, inyectamos el pkgs de la rama unstable
        pkgs = pkgsUnstable; 
        
        settings = (builtins.fromJSON (builtins.readFile ./noctalia.json)).settings;
      };
    };
}
