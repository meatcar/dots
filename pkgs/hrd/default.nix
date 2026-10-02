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
  version = "1.10.1";

  src = fetchFromGitHub {
    owner = "hugoh";
    repo = "hrd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-213IK2HOcg1+626YZp1a9vDkEA8WyV4vc3A9cKxqoTE=";
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
    homepage = "https://github.com/hugoh/hrd";
    license = lib.licenses.mit;
    mainProgram = "hrd";
  };
})
