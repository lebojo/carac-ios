// Resizes the raw simulator captures from the iOS project's App Store folder into
// the web JPGs used by the site, as `<name>-light.jpg` / `<name>-dark.jpg` pairs.
import fs from "node:fs";
import path from "node:path";
import sharp from "sharp";

const RAW_DIR =
  process.env.SCREENSHOTS_RAW_DIR ||
  path.resolve(process.cwd(), "..", "AppStore", "Screenshots", "raw");
const OUTPUT_DIR = path.resolve(process.cwd(), "public", "screenshots");
const HEIGHT = 1200;
const LANGUAGE = "en";
const THEMES = ["light", "dark"];

const SCREENSHOTS = {
  iphone: ["01-home", "02-exercise", "04-progress", "05-calendar", "06-trainings"],
  ipad: ["01-home"],
};

const jobs = Object.entries(SCREENSHOTS).flatMap(([device, names]) =>
  names.flatMap((name) =>
    THEMES.map((theme) => ({
      input: path.join(RAW_DIR, device, LANGUAGE, theme, `${name}.png`),
      output: path.join(OUTPUT_DIR, device, `${name}-${theme}.jpg`),
    }))
  )
);

const missing = jobs.filter((job) => !fs.existsSync(job.input));

if (missing.length > 0) {
  console.error(
    `Missing raw screenshots:\n${missing.map((job) => `  ${job.input}`).join("\n")}\nSet SCREENSHOTS_RAW_DIR to use another folder.`
  );
  process.exit(1);
}

for (const job of jobs) {
  fs.mkdirSync(path.dirname(job.output), { recursive: true });
  await sharp(job.input)
    .resize({ height: HEIGHT })
    .flatten({ background: "#ffffff" })
    .jpeg({ quality: 82, mozjpeg: true })
    .toFile(job.output);
  console.log(`Saved ${path.relative(process.cwd(), job.output)}`);
}
