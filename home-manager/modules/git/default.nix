{
  pkgs,
  inputs,
  nixpkgs-unstable,
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
    package = pkgs.gitFull;
    lfs.enable = true;
    settings = {
      user.name = "Denys Pavlov";
      user.email = "me@denys.me";
      user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcq01gh2tn/+hcm75N3LnS003mUBjXcT6qNndMhObPO";
      commit.template = "${gitmessage}";

      gpg = {
        format = "ssh";
      };
      commit = {
        gpgsign = true;
      };
    };
    includes = [
      { path = ./config; }
      { path = "${inputs.catppuccin-delta}/catppuccin.gitconfig"; }
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

  home.packages =
    (with pkgs; [
      glab # gitlab CLI
      git-absorb # quick fixup rebases
      lab # gitlab cli
      hub # github cli (pre-gh, less official)
    ])
    ++ (with nixpkgs-unstable; [
      gitu # cli magit
    ]);

  xdg.configFile."gitu/config.toml".source = ./gitu-config.toml;

  programs.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
    };
  };

  programs.delta = {
    enable = true;
    options = {
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
  };

  programs.lazygit = {
    enable = true;
    settings = {
      reporting = "off";
      disableStartupPopups = true;
      gui = {
        showFileTree = true;
        nerdFontsVersion = "3";
        useHunkModeInStagingView = false;
        theme = {
          selectedLineBgColor = [ "reverse" ];
          selectedRangeBgColor = [ "reverse" ];
        };
      };
      git.pagers = [
        {
          colorArg = "always";
          pager = "${pkgs.delta}/bin/delta --paging=never";
        }
      ];
    };
  };

  programs.fish.shellInit = ''
    set -x DELTA_FEATURES "+$(get-theme)"
  '';
}
