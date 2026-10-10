import { readFileSync } from "node:fs";

const [, , tsPath] = process.argv;
const match = readFileSync(tsPath, "utf8").match(/const cSource = `([^`$]*)`;/);
if (!match) {
  console.error(`extract-xu-helper: no interpolation-free cSource literal in ${tsPath}`);
  process.exit(1);
}
process.stdout.write(new Function(`return \`${match[1]}\`;`)());
