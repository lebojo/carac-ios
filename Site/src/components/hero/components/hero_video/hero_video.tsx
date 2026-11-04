"use client";

import { Icon } from "@/components/icon/icon";
import { useBezelVideoRenderer } from "@/hooks/useBezelVideoRenderer";
import { DEVICE_BEZEL_CONFIGURATION_MAP } from "@/lib/device_bezel_configuration_map";
import type { Bezel, ImageSrcsetEntry } from "@/types/shared";
import Image from "next/image";
import { useEffect, useRef, useState } from "react";
import styles from "./hero_video.module.css";

interface HeroVideoProps {
  src: string;
  bezel: Bezel;
  srcset?: ImageSrcsetEntry[];
  alt?: string;
}

export function HeroVideo({ src, srcset, alt = "", bezel }: HeroVideoProps) {
  const [isPaused, setIsPaused] = useState(false);
  const hiddenVideoContainerRef = useRef<HTMLDivElement>(null);
  const canvasRef = useRef<HTMLCanvasElement>(null);

  const videoElement = useBezelVideoRenderer({
    canvasRef,
    src,
    srcset,
    bezel,
  });

  useEffect(() => {
    if (
      !videoElement ||
      !hiddenVideoContainerRef.current ||
      hiddenVideoContainerRef.current.hasChildNodes()
    ) {
      return;
    }

    const handlePlay = () => {
      setIsPaused(false);
    };

    const handlePause = () => {
      setIsPaused(true);
    };

    hiddenVideoContainerRef.current.appendChild(videoElement);

    videoElement.addEventListener("play", handlePlay);
    videoElement.addEventListener("pause", handlePause);

    return () => {
      videoElement.removeEventListener("play", handlePlay);
      videoElement.removeEventListener("pause", handlePause);
    };
  }, [videoElement]);

  const onFullScreenButtonClick = () => {
    if (!videoElement) {
      return;
    }

    if (videoElement.requestFullscreen) {
      videoElement.requestFullscreen();
    } else {
      const webkitVideoElement = videoElement as HTMLVideoElement & {
        webkitEnterFullscreen?: () => void;
      };

      if (typeof webkitVideoElement.webkitEnterFullscreen === "function") {
        webkitVideoElement.webkitEnterFullscreen(); // iOS
      }
    }
  };

  const onPlayPauseButtonClick = () => {
    if (!videoElement) {
      return;
    }

    if (videoElement.paused) {
      videoElement.play().catch((error) => {
        console.error("Failed to play the video.", error);
      });
    } else {
      videoElement.pause();
    }
  };

  const bezelConfig = DEVICE_BEZEL_CONFIGURATION_MAP[bezel];

  return (
    <div className={styles.heroVideo}>
      <div
        className={styles.hiddenVideoContainer}
        ref={hiddenVideoContainerRef}
      ></div>
      <div
        className={styles.shadow}
        style={
          {
            ["--bottom-offset"]: `${bezelConfig.shadowBottomOffset}px`,
          } as React.CSSProperties
        }
      >
        <Image
          src="/app_view/iphone_shadow.png"
          alt=""
          width={592}
          height={68}
          style={{ width: "100%", height: "auto" }}
        />
      </div>

      <canvas ref={canvasRef} className={styles.videoCanvas} aria-label={alt} />

      <div className={styles.controls}>
        <button type="button" onClick={onFullScreenButtonClick}>
          <Icon name="open_in_full" size={14} />
        </button>
        <button
          type="button"
          onClick={onPlayPauseButtonClick}
          aria-label={isPaused ? "Play demo video" : "Pause demo video"}
        >
          {isPaused ? (
            <Icon name="play_arrow" size={14} />
          ) : (
            <Icon name="pause" size={14} />
          )}
        </button>
      </div>
    </div>
  );
}
