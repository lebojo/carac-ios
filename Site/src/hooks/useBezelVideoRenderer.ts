import { DEVICE_BEZEL_CONFIGURATION_MAP } from "@/lib/device_bezel_configuration_map";
import { findSrcForTheme, loadImage, loadVideo } from "@/lib/utils";
import { useEffect, useRef, useState } from "react";
import type {
  Bezel,
  BezelCropConfiguration,
  ImageSrcsetEntry,
} from "../types/shared";
import { useTheme } from "./useTheme";

interface UseBezelVideoRendererParams {
  canvasRef: React.RefObject<HTMLCanvasElement>;
  src: string;
  bezel: Bezel;
  srcset?: ImageSrcsetEntry[];
  crop?: BezelCropConfiguration;
}

const PLACEHOLDER_SRC = "/app_view/recording_placeholder.mov";

export function useBezelVideoRenderer({
  canvasRef,
  src,
  srcset,
  bezel,
  crop,
}: UseBezelVideoRendererParams): HTMLVideoElement | null {
  const theme = useTheme();
  const animationFrameRef = useRef<number | null>(null);
  const [videoElement, setVideoElement] = useState<HTMLVideoElement | null>(
    null
  );
  const isCanvasVisibleRef = useRef(true);

  const cropTopRatio =
    crop?.edge === "top" ? Math.min(Math.max(crop.croppedRatio, 0), 1) : 0;
  const cropBottomRatio =
    crop?.edge === "bottom" ? Math.min(Math.max(crop.croppedRatio, 0), 1) : 0;

  /**
   * biome-ignore lint/correctness/useExhaustiveDependencies: the video should
   * reload only when theme or canvas element changes, and should not reload
   * when the video element is set
   */
  useEffect(() => {
    if (theme === null || canvasRef.current === null) {
      return;
    }

    let isCancelled = false;

    const bezelConfig = DEVICE_BEZEL_CONFIGURATION_MAP[bezel];
    const videoSrc = findSrcForTheme(src, srcset, theme);

    const canvas = canvasRef.current;
    const ctx = canvas?.getContext("2d");

    if (!bezelConfig || !canvas || !ctx) {
      return;
    }

    const scratchCanvas = document.createElement("canvas");
    const scratchCtx = scratchCanvas.getContext("2d");
    const globalBackgroundColor = getGlobalBackgroundColor();

    if (!scratchCtx) {
      return;
    }

    Promise.all([
      loadVideo(videoSrc),
      loadImage(bezelConfig.src),
      loadImage(bezelConfig.maskSrc),
    ])
      .then(([video, bezelImg, maskImg]) => {
        if (isCancelled) {
          video.pause();
          return;
        }

        setVideoElement(video);

        const targetWidth = bezelImg.naturalWidth;
        const targetHeight = bezelImg.naturalHeight;
        const croppedTargetHeight =
          targetHeight * (1 - cropTopRatio - cropBottomRatio);

        const { horizontalOffset, verticalOffset } = bezelConfig;

        scratchCanvas.width = targetWidth;
        scratchCanvas.height = targetHeight;
        canvas.width = targetWidth;
        canvas.height = croppedTargetHeight;

        scratchCtx.imageSmoothingEnabled = true;
        scratchCtx.imageSmoothingQuality = "high";
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = "high";

        /**
         * Track the last frame we've already painted so we can skip redundant redraws.
         */
        let lastRenderedTime = -1;

        const drawFrame = () => {
          if (isCancelled) {
            return;
          }

          const currentTime = video.currentTime;

          if (currentTime !== lastRenderedTime) {
            lastRenderedTime = currentTime;

            scratchCtx.clearRect(0, 0, targetWidth, targetHeight);

            const sourceWidth = video.videoWidth || targetWidth;
            const sourceHeight = video.videoHeight || targetHeight;

            scratchCtx.drawImage(
              video,
              0,
              0,
              sourceWidth,
              sourceHeight,
              horizontalOffset,
              verticalOffset,
              targetWidth - horizontalOffset * 2,
              targetHeight - verticalOffset * 2
            );

            if (videoSrc === PLACEHOLDER_SRC && globalBackgroundColor) {
              scratchCtx.save();
              scratchCtx.globalCompositeOperation = "color";
              scratchCtx.fillStyle = globalBackgroundColor;
              scratchCtx.globalAlpha = 0.55;
              scratchCtx.fillRect(0, 0, targetWidth, targetHeight);
              scratchCtx.restore();
            }

            scratchCtx.save();
            scratchCtx.globalCompositeOperation = "destination-in";
            scratchCtx.drawImage(
              maskImg,
              0,
              0,
              maskImg.naturalWidth,
              maskImg.naturalHeight,
              0,
              0,
              targetWidth,
              targetHeight
            );
            scratchCtx.restore();

            scratchCtx.drawImage(
              bezelImg,
              0,
              0,
              bezelImg.naturalWidth,
              bezelImg.naturalHeight,
              0,
              0,
              targetWidth,
              targetHeight
            );

            ctx.clearRect(0, 0, targetWidth, croppedTargetHeight);
            ctx.drawImage(
              scratchCanvas,
              0,
              targetHeight * cropTopRatio,
              targetWidth,
              croppedTargetHeight,
              0,
              0,
              targetWidth,
              croppedTargetHeight
            );
          }

          animationFrameRef.current = requestAnimationFrame(drawFrame);
        };

        drawFrame();

        isCanvasVisibleRef.current ? video.play() : video.pause();
      })
      .catch((error) => {
        console.error(error);
      });

    return () => {
      isCancelled = true;

      if (animationFrameRef.current !== null) {
        cancelAnimationFrame(animationFrameRef.current);
        animationFrameRef.current = null;
      }
    };
  }, [theme, canvasRef, bezel, src, srcset, cropTopRatio, cropBottomRatio]);

  useEffect(() => {
    const canvasElement = canvasRef.current;

    if (!canvasElement) {
      return;
    }

    const observer = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          isCanvasVisibleRef.current = entry.isIntersecting;

          if (!videoElement) {
            return;
          }

          if (entry.isIntersecting) {
            videoElement.play().catch((error) => {
              console.error(error);
            });
          } else {
            videoElement.pause();
          }
        });
      },
      { threshold: 0.4 }
    );

    observer.observe(canvasElement);

    return () => {
      observer.disconnect();
    };
  }, [canvasRef, videoElement]);

  return videoElement;
}

function getGlobalBackgroundColor(): string {
  return getComputedStyle(window.document.documentElement).getPropertyValue(
    "--color-fill-1"
  );
}
