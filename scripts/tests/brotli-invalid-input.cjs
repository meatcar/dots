const assert = require("node:assert/strict");
const { brotliDecompressSync } = require("node:zlib");

let errno;
try {
  brotliDecompressSync(Buffer.from("200010414141fcffff07002228f00b60f7f41f000000", "hex"));
} catch (error) {
  errno = error.errno;
}
assert.equal(errno, -17);
