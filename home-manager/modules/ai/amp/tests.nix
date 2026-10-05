{
  runCommand,
  writeText,
  python3,
  bubblewrap,
  openssh,
}:
let
  generation =
    name:
    runCommand "amp-ssh-fixtures-${name}" { } ''
      mkdir -p "$out/etc/ssh/ssh_config.d" "$out/lib/systemd/ssh_config.d"
      cat > "$out/etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf" <<'EOF'
      Host qemu/* qemu:system/* qemu:session/*
        ProxyCommand /amp-fixture-${name}/libvirt-ssh-proxy %h %p
        ProxyUseFdpass yes
        CheckHostIP no
      EOF
      cat > "$out/lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf" <<'EOF'
      Host .host vsock/*
        ProxyCommand /amp-fixture-${name}/systemd-ssh-proxy %h %p
        ProxyUseFdpass yes
        CheckHostIP no
      EOF
    '';
  a = generation "a";
  b = generation "b";
  sshConfig = writeText "amp-test-ssh-config" ''
    Include ${a}/etc/ssh/ssh_config.d/30-libvirt-ssh-proxy.conf
    Host *
    Include ${a}/lib/systemd/ssh_config.d/20-systemd-ssh-proxy.conf
    GlobalKnownHostsFile /etc/ssh/ssh_known_hosts
    ForwardX11 no
  '';
  nsswitch = writeText "amp-test-nsswitch" ''
    passwd: files
    group: files
  '';
in
runCommand "amp-accounts-check"
  {
    nativeBuildInputs = [
      python3
      bubblewrap
      openssh
    ];
    AMP_TEST_SSH_GENERATIONS = "${a}:${b}";
    PYTHONDONTWRITEBYTECODE = "1";
  }
  ''
    bwrap --bind / / --dev-bind /dev /dev \
      --tmpfs /etc \
      --ro-bind /etc/passwd /etc/passwd \
      --ro-bind /etc/group /etc/group \
      --ro-bind ${nsswitch} /etc/nsswitch.conf \
      --dir /etc/ssh \
      --ro-bind ${sshConfig} /etc/ssh/ssh_config \
      -- python3 -m unittest discover -s ${./.} -p 'test_*.py' -q
    touch "$out"
  ''
