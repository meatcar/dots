{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  fetchurl,
  autoPatchelfHook,
  tmuxPlugins,
  gcc-unwrapped,
  dbus,
  zlib,
}:
let
  version = "0.2.0-alpha.12";

  src = fetchFromGitHub {
    owner = "Ataraxy-Labs";
    repo = "opensessions";
    rev = "v${version}";
    hash = "sha256-1Xr4OaWGPO2wt6IS05LhwOXp+7LYSk8XG8e3mH6UPog=";
  };

  binaries = stdenvNoCC.mkDerivation {
    pname = "opensessions-binaries";
    inherit version;

    src = fetchurl {
      url = "https://github.com/Ataraxy-Labs/opensessions/releases/download/v${version}/opensessions-sidebar-x86_64-unknown-linux-gnu.tar.gz";
      hash = "sha256-GEBF1yDwyXSt0qF7nAVT4sfSyPw+FZSzt8T4yZC4LTU=";
    };

    nativeBuildInputs = [ autoPatchelfHook ];
    buildInputs = [
      gcc-unwrapped.lib
      dbus.lib
      zlib
    ];

    sourceRoot = ".";
    dontBuild = true;

    installPhase = ''
      runHook preInstall
      install -Dm755 opensessions-sidebar $out/bin/opensessions-sidebar
      install -Dm755 opensessions-server $out/bin/opensessions-server
      install -Dm755 lazydiff $out/bin/lazydiff
      echo -n "${version}" > $out/bin/.opensessions-version
      runHook postInstall
    '';
  };
in
tmuxPlugins.mkTmuxPlugin {
  pluginName = "opensessions";
  inherit version src;
  rtpFilePath = "opensessions.tmux";

  postInstall = ''
    mkdir -p $out/share/tmux-plugins/opensessions/bin
    ln -s ${binaries}/bin/opensessions-sidebar $out/share/tmux-plugins/opensessions/bin/opensessions-sidebar
    ln -s ${binaries}/bin/opensessions-server $out/share/tmux-plugins/opensessions/bin/opensessions-server
    ln -s ${binaries}/bin/lazydiff $out/share/tmux-plugins/opensessions/bin/lazydiff
    ln -s ${binaries}/bin/.opensessions-version $out/share/tmux-plugins/opensessions/bin/.opensessions-version

    # Prevent the .tmux entry point from trying to download binaries at runtime
    substituteInPlace $out/share/tmux-plugins/opensessions/opensessions.tmux \
      --replace-fail 'sh "$SCRIPTS_DIR/install-binaries.sh"' ': # skipped – binaries provided by Nix'
  '';

  meta = {
    description = "Tmux sidebar for managing AI coding agent sessions";
    homepage = "https://github.com/Ataraxy-Labs/opensessions";
    license = lib.licenses.mit;
    platforms = [ "x86_64-linux" ];
    mainProgram = "opensessions-sidebar";
  };
}
