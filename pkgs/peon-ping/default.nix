{
  lib,
  stdenvNoCC,
  makeWrapper,
  bash,
  python3,
  coreutils,
  gnugrep,
  pipewire,
  pulseaudio,
  libnotify,
  xdotool,
  src,
  packsSrc,
}:
stdenvNoCC.mkDerivation {
  pname = "peon-ping";
  version = "0-unstable";

  inherit src;

  nativeBuildInputs = [ makeWrapper ];

  dontBuild = true;

  installPhase = ''
    runHook preInstall

    # main script
    install -Dm755 peon.sh $out/libexec/peon-ping/peon.sh

    # sound packs (from separate og-packs repo)
    mkdir -p $out/share/peon-ping
    cp -r ${packsSrc} $out/share/peon-ping/packs

    # completions
    install -Dm644 completions.bash \
      $out/share/bash-completion/completions/peon
    install -Dm644 completions.fish \
      $out/share/fish/vendor_completions.d/peon.fish

    # wrapper with pinned PATH (no curl/wget/git)
    makeWrapper $out/libexec/peon-ping/peon.sh $out/bin/peon \
      --set PATH ${
        lib.makeBinPath [
          bash
          python3
          coreutils
          gnugrep
          pipewire
          pulseaudio
          libnotify
          xdotool
        ]
      } \
      --run 'export CLAUDE_PEON_DIR="''${CLAUDE_PEON_DIR:-$HOME/.claude/hooks/peon-ping}"'

    runHook postInstall
  '';

  meta = {
    description = "Gaming audio notifications for Claude Code hooks";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    mainProgram = "peon";
  };
}
