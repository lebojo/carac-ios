/* eslint-disable @next/next/no-img-element */
"use client";

import { useBezelImageRenderer } from "@/hooks/useBezelImageRenderer";
import { useTheme } from "@/hooks/useTheme";
import { findSrcForTheme } from "@/lib/utils";
import { useRef } from "react";
import type {
	Bezel,
	BezelCropConfiguration,
	ImageSrcsetEntry,
} from "../../../../../../types/shared";
import styles from "../../stacked_card_shared.module.css";

interface StackedCardImageProps {
  src: string;
  srcset?: ImageSrcsetEntry[];
  alt: string;
  padded?: boolean;
  bezel?: Bezel;
  bezelCrop?: BezelCropConfiguration;
}

export function StackedCardImage({
  src,
  srcset,
  alt,
  bezel,
  bezelCrop,
  padded = true,
}: StackedCardImageProps) {
  const theme = useTheme();
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useBezelImageRenderer({
    canvasRef,
    src,
    srcset,
    bezel: bezel || "iPhone 17 Black",
    crop: bezelCrop,
  });

  /**
   * The theme is null during static-site generation
   */
  if (theme === null) {
    return null;
  }

  const croppedTopClassName =
    bezel && bezelCrop?.edge === "top" ? styles.croppedTop : "";
  const croppedBottomClassName =
    bezel && bezelCrop?.edge === "bottom" ? styles.croppedBottom : "";
  const paddedClassName = padded ? styles.padded : "";

  return (
    <div className={styles.stackedCardMedia}>
      {bezel === undefined && (
        <img
          loading="lazy"
          decoding="async"
          src={findSrcForTheme(src, srcset, theme ?? "light")}
          alt={alt}
          className={`${styles.mediaObject} ${paddedClassName}`}
        />
      )}
      {bezel !== undefined && (
        <canvas
          ref={canvasRef}
          className={`${styles.mediaObject} ${paddedClassName} ${croppedTopClassName} ${croppedBottomClassName}`}
          aria-label={alt}
        />
      )}
    </div>
  );
}
