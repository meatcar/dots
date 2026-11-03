{
  runCommand,
  python3,
  ffmpeg,
}:
runCommand "audio-record-check"
  {
    nativeBuildInputs = [
      python3
      ffmpeg
    ];
    PYTHONDONTWRITEBYTECODE = "1";
  }
  ''
    python3 -m unittest discover -s ${./.} -p 'test_*.py' -q
    touch "$out"
  ''
