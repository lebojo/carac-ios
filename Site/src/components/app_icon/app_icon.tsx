"use client";

import { useTheme } from "@/hooks/useTheme";
import { findSrcForTheme } from "@/lib/utils";
import Image from "next/image";
import { ImageSrcsetEntry } from "../../types/shared";
import styles from "./app_icon.module.css";

interface AppIconProps {
  src: string;
  srcset?: ImageSrcsetEntry[];
  mask?: boolean;
  size?: number;
  filter?: "none" | "grayscale";
}

const PLACEHOLDER_SRC = "/app_view/icon_placeholder.png";

export function AppIcon({
  src,
  srcset,
  mask = false,
  size = 40,
  filter = "none",
}: AppIconProps) {
  const theme = useTheme();

  /**
   * The theme is null during static-site generation
   */
  if (theme === null) {
    return null;
  }

  const targetSrc = findSrcForTheme(src, srcset, theme);
  const accentBrandColor = getAccentBrandColor();

  let filterClassName;

  switch (filter) {
    case "none":
      filterClassName = "";
      break;
    case "grayscale":
      filterClassName = styles.grayscale;
      break;
    default:
      filterClassName = "";
  }

  return (
    <figure
      className={`${styles.appIcon} ${
        mask ? styles.mask : ""
      } ${filterClassName}`}
    >
      <Image src={targetSrc} alt="App Icon" width={size} height={size} />

      {targetSrc === PLACEHOLDER_SRC &&
        filter === "none" &&
        accentBrandColor &&
        !["OKLCH(0% 0 NONE)", "OKLCH(100% 0 NONE)"].includes(
          accentBrandColor
        ) && <div className={styles.tintOverlay}></div>}
    </figure>
  );
}

function getAccentBrandColor(): string {
  if (typeof window === "undefined") {
    return "";
  }

  return getComputedStyle(window.document.documentElement)
    .getPropertyValue("--color-accent-brand")
    .trim()
    .toUpperCase();
}
