// GitHub Pages serves `out/policy.html` at `/policy` but answers 404 for `/policy/`.
// Store reviewers and crawlers may normalise URLs with a trailing slash, so copy each
// exported page to `<route>/index.html` to make both forms resolve.
import { copyFile, mkdir, readdir } from "node:fs/promises";
import path from "node:path";

const outDir = path.resolve(process.argv[2] ?? "out");
const skipped = new Set(["index.html", "404.html", "_not-found.html"]);

for (const entry of await readdir(outDir, { withFileTypes: true })) {
  if (!entry.isFile() || !entry.name.endsWith(".html") || skipped.has(entry.name)) continue;
  const route = entry.name.slice(0, -".html".length);
  await mkdir(path.join(outDir, route), { recursive: true });
  await copyFile(path.join(outDir, entry.name), path.join(outDir, route, "index.html"));
  console.log(`added ${route}/index.html`);
}
