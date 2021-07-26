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
    inherit (pkgs.perlPackages) PodPerldoc; # for mr
  };

  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      disableStartupPopups = true;
      gui = {
        showFileTree = true;
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
      git.paging = {
        colorArg = "always";
        pager = "${pkgs.gitAndTools.delta}/bin/delta --dark --paging=never --24-bit-color=never";
      };
    };
  };
}
