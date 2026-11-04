import fs from "node:fs";
import path from "node:path";
import sharp from "sharp";

const APP_ICON_PATH =
  process.env.APP_ICON_PATH ||
  path.resolve(process.cwd(), "public", "app-icon.png");
const FAVICON_OUTPUT_PATH = path.resolve(
  process.cwd(),
  "public",
  "favicon.png"
);
const SIZE = 48;

if (!fs.existsSync(APP_ICON_PATH)) {
  console.error(
    `${APP_ICON_PATH} does not exist. Provide a valid app icon path with APP_ICON_PATH environment variable.`
  );
  process.exit(1);
}

sharp(APP_ICON_PATH)
  .resize(SIZE, SIZE)
  .toFile(FAVICON_OUTPUT_PATH)
  .then(() => {
    console.log(`Favicon saved to ${FAVICON_OUTPUT_PATH}.`);
  })
  .catch((err) => {
    console.error("Error generating favicon:", err);
  });
