{ config, lib, ... }:
{
  options.me = {
    PRJ_ROOT = lib.mkOption {
      type = lib.types.str;
      default = "${config.home.homeDirectory}/git/hub/meatcar/dots/dots-default";
      description = "Absolute filesystem path to the working copy of this flake (PRJ_ROOT per prj-spec; used by mkOutOfStoreSymlink targets).";
    };

    identity = {
      name = lib.mkOption {
        type = lib.types.str;
        default = "Denys Pavlov";
        description = "Full name, used as the author identity in git and jj.";
      };
      email = lib.mkOption {
        type = lib.types.str;
        default = "me@denys.me";
        description = "Email address, used as the author identity in git and jj.";
      };
      username = lib.mkOption {
        type = lib.types.str;
        default = "meatcar";
        description = "Forge username, e.g. for jj push bookmark prefixes.";
      };
      jjEmail = lib.mkOption {
        type = lib.types.str;
        default = config.me.identity.email;
        defaultText = lib.literalExpression "config.me.identity.email";
        description = "Author email for jj, when it differs from the git one.";
      };
    };

    signing = {
      enable = lib.mkOption {
        type = lib.types.bool;
        default = false;
        description = "Whether to sign git commits and jj pushes.";
      };
      key = lib.mkOption {
        type = lib.types.str;
        default = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBcq01gh2tn/+hcm75N3LnS003mUBjXcT6qNndMhObPO";
        description = "SSH public key used to sign git commits and jj pushes.";
      };
    };
  };

  config = {
    programs.git.settings.user = {
      name = config.me.identity.name;
      email = config.me.identity.email;
    };
    programs.jujutsu.settings.user = {
      name = config.me.identity.name;
      email = config.me.identity.jjEmail;
    };
  };
}
