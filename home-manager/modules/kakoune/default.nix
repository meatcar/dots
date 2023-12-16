{
  config,
  pkgs,
  specialArgs,
  ...
}: {
  programs.kakoune = {
    enable = true;
    config = {
      showMatching = true;
      ui = {
        enableMouse = true;
        assistant = "none";
      };
      wrapLines = {
        enable = true;
        indent = true;
        marker = "⏎";
        word = true;
      };
    };
    plugins = [pkgs.kakounePlugins.parinfer-rust];
    extraConfig = ''

      ${builtins.readFile ./kakrc}
    '';
  };

  xdg.configFile."kak/plugins/plug.kak".source = specialArgs.inputs.plug-kak;

  home.packages = with pkgs; [fzf];
}
