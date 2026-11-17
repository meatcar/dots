{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  pkg-config,
  shaderc,
  spirv-headers,
  vulkan-headers,
  vulkan-loader,
}:
stdenv.mkDerivation {
  pname = "parakeet-cpp";
  # NOTE: diarization (`scene --diar`) is only on master, not in v0.5.0.
  version = "0.5.0-unstable-2026-10-30";

  src = fetchFromGitHub {
    owner = "mudler";
    repo = "parakeet.cpp";
    rev = "2eac2e77d9c7ef8899f7a86a46e693ac5ac1a5cd";
    fetchSubmodules = true;
    hash = "sha256-JH0Ga6Yzn8GNzYnsRXhJzG04Yu2OO7xcJEFjwGyFfv0=";
  };

  # NOTE: upstream runs `git apply` at configure time; no git checkout in the sandbox.
  postPatch = ''
    for p in third_party/ggml-patches/*.patch; do
      patch -p1 -d third_party/ggml < "$p"
    done
    rm scripts/apply_ggml_patches.sh
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    shaderc
  ];

  buildInputs = [
    spirv-headers
    vulkan-headers
    vulkan-loader
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_SHARED_LIBS" false)
    (lib.cmakeBool "GGML_NATIVE" false)
    (lib.cmakeBool "PARAKEET_GGML_VULKAN" true)
    (lib.cmakeBool "PARAKEET_BUILD_SERVER" false)
    (lib.cmakeBool "PARAKEET_WITH_CED" false)
    (lib.cmakeBool "PARAKEET_WITH_VOICEDETECT" false)
  ];

  ninjaFlags = [ "parakeet-cli" ];

  installPhase = ''
    runHook preInstall
    install -Dm755 examples/cli/parakeet-cli "$out/bin/parakeet-cli"
    runHook postInstall
  '';

  meta = {
    description = "NeMo Parakeet speech recognition and Nemotron diarization on ggml";
    homepage = "https://github.com/mudler/parakeet.cpp";
    license = lib.licenses.mit;
    mainProgram = "parakeet-cli";
    platforms = lib.platforms.linux;
  };
}
