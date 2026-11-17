{
  lib,
  writers,
  fetchurl,
  ffmpeg,
  parakeet-cpp,
}:
let
  # NOTE: pinned revision; HF re-uploads break hashes on `main`.
  model =
    name: hash:
    fetchurl {
      url = "https://huggingface.co/mudler/parakeet-cpp-gguf/resolve/07a08a3a405d20c5434b9a1442f6e6cf571f57ad/${name}";
      inherit hash;
    };
in
writers.writePython3Bin "parakeet-transcribe" {
  flakeIgnore = [
    "E501" # ruff-format line length
    "W503"
  ];
  makeWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      ffmpeg
      parakeet-cpp
    ])
    "--set-default"
    "PARAKEET_ASR_MODEL"
    (model "phonon-2.5-english-q8_0.gguf" "sha256-xIT2c+eHN2GjHDjCYpr+CXXfsgJSknMP69k/Y1SJrXA=")
    "--set-default"
    "PARAKEET_DIAR_MODEL"
    (model "nemotron-3-diarization-q8_0.gguf" "sha256-dsW7H7INgnBhQq0ydpt6tJbSRYSJRzoAD9cHTFLO7CI=")
  ];
} (builtins.readFile ./parakeet_transcribe.py)
