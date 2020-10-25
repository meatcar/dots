{ pkgs, ... }: {
  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "me@denys.me";
    userName = "Denys Pavlov";
    includes = [{ path = ./config; }];
    attributes = [
      "*.c     diff=cpp"
      "*.h     diff=cpp"
      "*.c++   diff=cpp"
      "*.h++   diff=cpp"
      "*.cpp   diff=cpp"
      "*.hpp   diff=cpp"
      "*.cc    diff=cpp"
      "*.hh    diff=cpp"
      "*.cs    diff=csharp"
      "*.css   diff=css"
      "*.html  diff=html"
      "*.xhtml diff=html"
      "*.ex    diff=elixir"
      "*.exs   diff=elixir"
      "*.go    diff=golang"
      "*.php   diff=php"
      "*.pl    diff=perl"
      "*.py    diff=python"
      "*.md    diff=markdown"
      "*.rb    diff=ruby"
      "*.rake  diff=ruby"
      "*.rs    diff=rust"
      "*.java  diff=java"
      "*.m     diff=objc"
      "*.mm    diff=objc"
    ];
  };

  programs.gh.enable = true;

  home.packages = builtins.attrValues {
    inherit (pkgs.gitAndTools) lab hub delta;
    inherit (pkgs) lazygit mr;
    inherit (pkgs.perl530Packages) PodPerldoc;# for mr
  };

  xdg.configFile."jesseduffield/lazygit/config.yml".text = ''
    reporting: "off"
    startuppopupversion: 1
    git:
      paging:
        colorArg: always
        # broken, see https://github.com/jesseduffield/lazygit/issues/893
        # pager: ${pkgs.gitAndTools.delta}/bin/delta --dark --paging=never --24-bit-color=never
        pager: ${pkgs.gitAndTools.diff-so-fancy}/bin/diff-so-fancy
  '';
}
