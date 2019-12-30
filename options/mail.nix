{ lib, ... }:
let
  inherit (lib) mkOption types;
in
{
  mail = {
    accounts = mkOption {
      description = "Email accounts";
      type = types.list;
      example = [
        {
          account = "gmail";
          primaryEmail = "test@example.com";
        }
      ];
    };
  };
}
