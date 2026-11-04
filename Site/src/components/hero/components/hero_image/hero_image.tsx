"use client";

import { useBezelImageRenderer } from "@/hooks/useBezelImageRenderer";
import { DEVICE_BEZEL_CONFIGURATION_MAP } from "@/lib/device_bezel_configuration_map";
import { publicPath } from "@/lib/public_path";
import type { Bezel, ImageSrcsetEntry } from "@/types/shared";
import Image from "next/image";
import { useRef } from "react";
import styles from "./hero_image.module.css";

interface HeroImageProps {
  src: string;
  srcset?: ImageSrcsetEntry[];
  alt: string;
  bezel: Bezel;
}

export function HeroImage({ src, srcset, alt, bezel }: HeroImageProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);

  useBezelImageRenderer({
    canvasRef,
    src,
    srcset,
    bezel: bezel,
  });

  const bezelConfig = DEVICE_BEZEL_CONFIGURATION_MAP[bezel];

  return (
    <div className={styles.heroImage}>
      <div
        className={styles.shadow}
        style={
          {
            ["--bottom-offset"]: `${bezelConfig.shadowBottomOffset}px`,
          } as React.CSSProperties
        }
      >
        <Image
          src={publicPath("/app_view/iphone_shadow.png")}
          alt=""
          width={592}
          height={68}
          style={{ width: "100%", height: "auto" }}
        />
      </div>
      <canvas ref={canvasRef} className={styles.imageCanvas} aria-label={alt} />
    </div>
  );
}
