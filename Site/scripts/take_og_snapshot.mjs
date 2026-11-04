#!/usr/bin/env node

import { execSync } from "node:child_process";
import path from "node:path";
import { webkit } from "playwright";

const APP_HOST = process.env.APP_HOST ?? "localhost";
const APP_PORT = process.env.APP_PORT ?? "3000";
const TARGET_URL =
  process.env.OG_SNAPSHOT_URL ??
  `http://${APP_HOST}:${APP_PORT}/open-graph-builder`;
const OUTPUT_PATH = process.argv[2] ?? path.join("public", "og-preview.png");

async function main() {
  execSync("npx playwright install webkit", { stdio: "inherit" });

  const browser = await webkit.launch({ headless: true });
  const page = await browser.newPage({
    /**
     * Intentionally making the hight taller to make the Next.js
     * dev indicator not overlap with the snapshot area.
     */
    viewport: { width: 1280, height: 1000 },
  });

  await page.goto(TARGET_URL, { waitUntil: "networkidle" });

  const snapshotContainerElement = page.locator(`.ogBuilderPreview`);
  const snapshotElement = page.locator(`.openGraphBuilderThemeRootContainer`);

  await snapshotContainerElement.evaluate((el) => {
    el.style.setProperty("--preview-scale-factor", "1");
  });

  await snapshotElement.evaluate((el) => {
    el.style.borderRadius = "0px";
  });

  await snapshotElement.screenshot({ path: OUTPUT_PATH });

  console.log(`Saved snapshot to ${OUTPUT_PATH}`);
  await browser.close();
}

main().catch((err) => {
  console.error(err);
  process.exit(1);
});
