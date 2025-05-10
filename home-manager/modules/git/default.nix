{
  pkgs,
  specialArgs,
  ...
}:
let
  gitmessage = pkgs.writeText "gitmessage" ''

    # type(scope): applying this commit will...
    # type: build ci chore docs feat fix perf refactor revert style test
    # !: breaking change
    #
    # What, Why, not how.
    #'';
in
{
  imports = [ ../mr ];

  programs.git = {
    enable = true;
    package = pkgs.gitAndTools.gitFull;
    lfs.enable = true;
    extraConfig = {
      user.name = "Denys Pavlov";
      user.email = "me@denys.me";
      commit.template = "${gitmessage}";
    };
    includes = [
      { path = ./config; }
      { path = "${specialArgs.inputs.catppuccin-delta}/catppuccin.gitconfig"; }
      {
        condition = "gitdir:~/git/hub/alipes/**";
        contents = {
          user.email = "denysp@alipes.com";
        };
      }
      {
        condition = "gitdir:~/git/hub/alipes/**";
        path = "~/git/hub/alipes/.gitconfig";
      }
    ];
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
    inherit (pkgs.gitAndTools)
      lab # gitlab cli
      hub # github cli (pre-gh, less official)
      delta # delta
      ;
    inherit (pkgs)
      glab # gitlab CLI
      git-absorb # quick fixup rebases
      gitu # cli magit
      git-crypt # transparent encryption
      ;
  };

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.git.delta.enable = true;
  programs.git.delta.options = {
    navigate = true;
    light = {
      light = true;
      features = "catppuccin-latte";
    };
    dark = {
      light = false;
      features = "catppuccin-mocha";
    };
  };

  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      disableStartupPopups = true;
      gui = {
        showFileTree = true;
        nerdFontsVersion = "3";
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
      git.paging = {
        colorArg = "always";
        pager = "${pkgs.gitAndTools.delta}/bin/delta --paging=never";
      };
    };
  };

  programs.fish.shellInit = ''
    set -x DELTA_FEATURES "+$(get-theme)"
  '';
}
