"use client";

import { useBezelVideoRenderer } from "@/hooks/useBezelVideoRenderer";
import { useTheme } from "@/hooks/useTheme";
import { findSrcForTheme } from "@/lib/utils";
import type {
	Bezel,
	BezelCropConfiguration,
	ImageSrcsetEntry,
} from "@/types/shared";
import { useRef } from "react";
import styles from "../../stacked_card_shared.module.css";

interface StackedCardVideoProps {
  src: string;
  srcset?: ImageSrcsetEntry[];
  padded?: boolean;
  bezel?: Bezel;
  bezelCrop?: BezelCropConfiguration;
}

export function StackedCardVideo({
  src,
  srcset,
  bezel,
  bezelCrop,
  padded = true,
}: StackedCardVideoProps) {
  const theme = useTheme();
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useBezelVideoRenderer({
    canvasRef,
    src,
    srcset,
    bezel: bezel || "iPhone 17 Black",
    crop: bezelCrop,
  });

  const croppedTopClassName =
    bezel && bezelCrop?.edge === "top" ? styles.croppedTop : "";
  const croppedBottomClassName =
    bezel && bezelCrop?.edge === "bottom" ? styles.croppedBottom : "";
  const paddedClassName = padded ? styles.padded : "";

  return (
    <div className={styles.stackedCardMedia}>
      {bezel === undefined && (
        <video
          src={findSrcForTheme(src, srcset, theme ?? "light")}
          className={`${styles.mediaObject} ${paddedClassName}`}
          autoPlay
          loop
          muted
          playsInline
        />
      )}
      {bezel !== undefined && (
        <canvas
          ref={canvasRef}
          className={`${styles.mediaObject} ${paddedClassName} ${croppedTopClassName} ${croppedBottomClassName}`}
        />
      )}
    </div>
  );
}
