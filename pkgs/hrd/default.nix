{
  lib,
  buildGoModule,
  fetchFromGitHub,
  git,
  jujutsu,
  installShellFiles,
  versionCheckHook,
}:
buildGoModule (finalAttrs: {
  pname = "hrd";
  version = "unstable-2026-10-04";

  src = fetchFromGitHub {
    owner = "meatcar";
    repo = "hrd";
    rev = "fde89f94431094c51496ffb3a6548f0455a33a4f";
    hash = "sha256-5jNiJUhTy0sC87KTgzVhVDK81e78nJor+amggCF6TdQ=";
  };

  vendorHash = "sha256-OxGT9+WgbG4H4uVyuZqq4yiZFAJIVw8mlKYrnJ9MyXU=";
  subPackages = [ "." ];
  ldflags = [
    "-s"
    "-w"
    "-X github.com/hugoh/hrd/cmd.version=${finalAttrs.version}"
  ];

  nativeBuildInputs = [ installShellFiles ];
  nativeCheckInputs = [
    git
    jujutsu
  ];
  checkPhase = ''
    runHook preCheck
    go test ./...
    runHook postCheck
  '';
  postInstall = ''
    installShellCompletion --cmd hrd \
      --bash <($out/bin/hrd completion bash) \
      --fish <($out/bin/hrd completion fish) \
      --zsh <($out/bin/hrd completion zsh)
  '';

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Multi-repository status and command runner for Git and Jujutsu";
    homepage = "https://github.com/meatcar/hrd";
    license = lib.licenses.mit;
    mainProgram = "hrd";
  };
})
