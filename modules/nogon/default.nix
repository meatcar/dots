# NOTE: Server is https://hister.vpn.denys.me, run from deploy.denys.me. Token: /run/user/1000/agenix/nogonToken.
_:
let
  forcelist = updateUrl: {
    text = builtins.toJSON {
      ExtensionInstallForcelist = [ "cciilamhchpmbdnniabclekddabkifhb;${updateUrl}" ];
    };
  };
  google = forcelist "https://clients2.google.com/service/update2/crx";
in
{
  environment.etc = {
    # NOTE: Helium reads this path too. Its update check omits prodversion, so Google answers noupdate.
    # see https://github.com/imputnet/helium/issues/1737
    "chromium/policies/managed/nogon.json" = forcelist "https://services.helium.imput.net/ext/";
    "vivaldi/policies/managed/nogon.json" = google;
    "opt/edge/policies/managed/nogon.json" = google;
  };
}
