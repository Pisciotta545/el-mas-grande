// Next exporta los datos de prefetch en subcarpetas (out/prode/__next.prode/__PAGE__.txt)
// pero el navegador los pide con puntos (out/prode/__next.prode.__PAGE__.txt).
// GitHub Pages no reescribe URLs, así que se deja también la versión con puntos.
import { copyFileSync, readdirSync, statSync } from "node:fs";
import { join } from "node:path";
import { fileURLToPath } from "node:url";

const OUT = fileURLToPath(new URL("../out/", import.meta.url));
let copied = 0;

function filesUnder(dir, prefix = []) {
  return readdirSync(dir).flatMap((name) => {
    const path = join(dir, name);
    return statSync(path).isDirectory() ? filesUnder(path, [...prefix, name]) : [[...prefix, name]];
  });
}

function walk(dir) {
  for (const name of readdirSync(dir)) {
    const path = join(dir, name);
    if (!statSync(path).isDirectory()) continue;
    if (name.startsWith("__next.")) {
      for (const parts of filesUnder(path)) {
        copyFileSync(join(path, ...parts), join(dir, [name, ...parts].join(".")));
        copied++;
      }
    } else {
      walk(path);
    }
  }
}

walk(OUT);
console.log(`flatten-prefetch: ${copied} archivos de prefetch con nombre plano`);
