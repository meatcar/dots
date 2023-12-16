{pkgs, ...}: let
  gitmessage = pkgs.writeText "gitmessage" ''

    # type(scope): applying this commit will...
    # type: build ci chore docs feat fix perf refactor revert style test
    # !: breaking change
    #
    # What, Why, not how.
    #'';
in {
  imports = [../mr];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    userEmail = "me@denys.me";
    userName = "Denys Pavlov";
    includes = [{path = ./config;}];
    extraConfig = {
      commit.template = "${gitmessage}";
    };
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

  home.packages = builtins.attrValues {
    inherit (pkgs.gitAndTools) lab hub delta;
    inherit (pkgs) glab;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      disableStartupPopups = true;
      gui = {
        showFileTree = true;
        theme = {
          selectedLineBgColor = ["reverse"];
          selectedRangeBgColor = ["reverse"];
        };
      };
      git.paging = {
        colorArg = "always";
        pager = "${pkgs.gitAndTools.delta}/bin/delta";
      };
    };
  };

  programs.fish.shellInit = ''
    set -x DELTA_FEATURES "+$(get-theme)"
  '';
}
