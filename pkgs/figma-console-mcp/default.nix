{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
}:
buildNpmPackage (finalAttrs: {
  pname = "figma-console-mcp";
  version = "1.40.9";

  src = fetchFromGitHub {
    owner = "southleft";
    repo = "figma-console-mcp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fxukSIJrXejUz5Y6uDd+/ksYnUrDr6JIWj6dX6xBOg4=";
  };

  npmDepsHash = "sha256-Dxd5K152FV43e6YPXTjDWElT39ePwFFqYWtdmRBbirs=";
  npmBuildScript = "build:local";
  # NOTE: optional deps are ~370 MiB of bun binaries used only by ext-apps' own build tooling.
  npmPruneFlags = [ "--omit=optional" ];

  # NOTE: copyFileSync keeps the store's 0444 mode, so refreshing ~/.figma-console-mcp/plugin fails on the next start.
  postPatch = ''
    substituteInPlace src/local.ts \
      --replace-fail 'copyFileSync(src, dest);' 'writeFileSync(dest, readFileSync(src));'
  '';

  meta = {
    description = "MCP server for Figma design extraction, creation, and plugin debugging";
    homepage = "https://github.com/southleft/figma-console-mcp";
    license = lib.licenses.mit;
    mainProgram = "figma-console-mcp";
  };
})
