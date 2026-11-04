"use client";

import { useTheme } from "@/hooks/useTheme";
import { buildClassNameForFontStyle, findSrcForTheme } from "@/lib/utils";
import Image from "next/image";
import { ReactEventHandler, useState } from "react";
import type { FontStyle, ImageSrcsetEntry } from "../../../../types/shared";
import sharedGridStyles from "../../shared.module.css";
import styles from "./overlaid_card.module.css";

interface OverlaidCardProps {
  maxWidth: "third" | "half" | "twoThirds" | "full";
  imageSrc: string;
  imageSrcset?: ImageSrcsetEntry[];
  title: string;
  titleFontStyle?: FontStyle;
  description?: string;
  textAlignment?:
    | "center"
    | "topLeading"
    | "topCenter"
    | "topTrailing"
    | "bottomLeading"
    | "bottomCenter"
    | "bottomTrailing";
  /**
   * By default the component will analyze the background image brightness
   * and select an appropriate text color theme, but you can override that
   * behavior by specifying this property.
   */
  textColorTheme?: "dark" | "light";
}

export function OverlaidCard({
  maxWidth,
  imageSrc,
  imageSrcset,
  title,
  titleFontStyle = "sans",
  description,
  textAlignment = "center",
  textColorTheme,
}: OverlaidCardProps) {
  const [textBackgroundClassName, setTextBackgroundClassName] = useState(() => {
    if (!textColorTheme) {
      return "";
    }

    return textColorTheme === "dark"
      ? styles.lightBackgroundImage
      : styles.darkBackgroundImage;
  });

  const titleFontStyleClass = buildClassNameForFontStyle(titleFontStyle, {
    whimsical: styles.whimsical,
    cursive: styles.cursive,
  });

  const onCalculateImageBrightness =
    textBackgroundClassName === ""
      ? (brightness: number) => {
          setTextBackgroundClassName(
            brightness < 150
              ? styles.darkBackgroundImage
              : styles.lightBackgroundImage
          );
        }
      : undefined;

  return (
    <figure
      className={`${sharedGridStyles.gridCardItem} ${sharedGridStyles[maxWidth]} ${styles.overlaidCard} ${styles[textAlignment]}`}
    >
      <div className={styles.image}>
        <BackgroundImage
          imageSrc={imageSrc}
          imageSrcset={imageSrcset}
          onCalculateBrightness={onCalculateImageBrightness}
        />
      </div>
      <div
        className={`${styles.text} ${styles[textAlignment]} ${textBackgroundClassName}`}
      >
        <h2 className={`${styles.title} ${titleFontStyleClass}`}>{title}</h2>
        <p className={styles.description}>{description}</p>
      </div>
    </figure>
  );
}

function BackgroundImage({
  imageSrc,
  imageSrcset,
  onCalculateBrightness,
}: {
  imageSrc: string;
  imageSrcset?: ImageSrcsetEntry[];
  onCalculateBrightness?: (brightness: number) => void;
}) {
  const theme = useTheme();

  /**
   * The theme is null during static-site generation
   */
  if (theme === null) {
    return null;
  }

  const onLoad: ReactEventHandler<HTMLImageElement> = (event) => {
    if (!onCalculateBrightness) {
      return;
    }

    onCalculateBrightness(getImageBrightness(event.target as HTMLImageElement));
  };
  const src = findSrcForTheme(imageSrc, imageSrcset, theme);

  return (
    <Image
      src={src}
      alt=""
      fill={true}
      style={{ objectFit: "cover" }}
      onLoad={onLoad}
    />
  );
}

const getDefaultBackgroundColor = (img: HTMLImageElement): string => {
  return getComputedStyle(img).getPropertyValue("--color-base-background");
};

function getImageBrightness(img: HTMLImageElement): number {
  const canvas = document.createElement("canvas");
  const ctx = canvas.getContext("2d");
  const defaultBackgroundColor = getDefaultBackgroundColor(img);

  // Resize so we don't process huge images
  const width = 50;
  const height = 50;
  canvas.width = width;
  canvas.height = height;

  ctx.fillStyle = defaultBackgroundColor;
  ctx.fillRect(0, 0, width, height);
  ctx.drawImage(img, 0, 0, width, height);

  const imageData = ctx.getImageData(0, 0, width, height);
  const data = imageData.data;

  let colorSum = 0;

  // data = [r,g,b,a, r,g,b,a, ...]
  for (let x = 0; x < data.length; x += 4) {
    const r = data[x];
    const g = data[x + 1];
    const b = data[x + 2];

    // perceived luminance
    const avg = 0.299 * r + 0.587 * g + 0.114 * b;

    colorSum += avg;
  }

  return colorSum / (data.length / 4); // 0–255
}
