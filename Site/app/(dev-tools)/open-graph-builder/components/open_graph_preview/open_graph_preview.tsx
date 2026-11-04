"use client";

import { ClientRuntimeThemeContext } from "@/contexts/client_runtime_theme_context";
import { useBezelImageRenderer } from "@/hooks/useBezelImageRenderer";
import { buildClassNameForFontStyle } from "@/lib/utils";
import type { Bezel, BezelCropConfiguration, FontStyle } from "@/types/shared";
import { useRef } from "react";
import styles from "./open_graph_preview.module.css";
import { AppIcon } from "@/components/app_icon/app_icon";

interface OpenGraphPreviewProps {
  title: string;
  titleFontStyle?: FontStyle;
  iconSrc: string;
  screenshotSrc: string;
  bezel: Bezel;
  bezelCrop?: BezelCropConfiguration;
  theme?: "light" | "dark";
}

export function OpenGraphPreview(props: OpenGraphPreviewProps) {
  return (
    <ClientRuntimeThemeContext.Provider value={props.theme}>
      <OpenGraphPreviewContent {...props} />
    </ClientRuntimeThemeContext.Provider>
  );
}

export const OPEN_GRAPH_BUILDER_THEME_ROOT_CONTAINER_CLASSNAME =
  "openGraphBuilderThemeRootContainer";

function OpenGraphPreviewContent({
  title,
  titleFontStyle,
  iconSrc,
  screenshotSrc,
  bezel,
  bezelCrop,
  theme = "light",
}: OpenGraphPreviewProps) {
  const canvasRef = useRef<HTMLCanvasElement>(null);
  const previewFrameRef = useRef<HTMLDivElement>(null);

  const croppedTopClassName =
    bezel && bezelCrop?.edge === "top" ? styles.croppedTop : "";
  const croppedBottomClassName =
    bezel && bezelCrop?.edge === "bottom" ? styles.croppedBottom : "";

  const titleFontStyleClass = buildClassNameForFontStyle(titleFontStyle, {
    whimsical: styles.whimsical,
    cursive: styles.cursive,
  });

  useBezelImageRenderer({
    canvasRef,
    src: screenshotSrc,
    bezel: bezel || "iPhone 17 Black",
    crop: bezelCrop,
  });

  return (
    <div
      className={`${OPEN_GRAPH_BUILDER_THEME_ROOT_CONTAINER_CLASSNAME} ${styles.openGraphPreview}`}
      data-theme={theme}
      ref={previewFrameRef}
    >
      <div className={styles.content}>
        <AppIcon src={iconSrc} size={180} />
        <h1 className={`${styles.title} ${titleFontStyleClass}`}>{title}</h1>
      </div>

      <div className={styles.screenshot}>
        <canvas
          ref={canvasRef}
          className={`${styles.screenshotCanvas} ${croppedTopClassName} ${croppedBottomClassName}`}
          width={580}
          height={660}
        />
      </div>
    </div>
  );
}
