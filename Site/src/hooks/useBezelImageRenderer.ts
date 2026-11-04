import { DEVICE_BEZEL_CONFIGURATION_MAP } from "@/lib/device_bezel_configuration_map";
import { findSrcForTheme, loadImage } from "@/lib/utils";
import { useEffect } from "react";
import type {
  Bezel,
  BezelCropConfiguration,
  ImageSrcsetEntry,
} from "../types/shared";
import { useTheme } from "./useTheme";

const PLACEHOLDER_SRC = "/app_view/screenshot_placeholder.png";

export function useBezelImageRenderer({
  canvasRef,
  src,
  srcset,
  bezel,
  crop,
}: {
  canvasRef: React.RefObject<HTMLCanvasElement>;
  src: string;
  bezel: Bezel;
  srcset?: ImageSrcsetEntry[];
  crop?: BezelCropConfiguration;
}) {
  const theme = useTheme();

  const cropTopRatio =
    crop?.edge === "top" ? Math.min(Math.max(crop.croppedRatio, 0), 1) : 0;
  const cropBottomRatio =
    crop?.edge === "bottom" ? Math.min(Math.max(crop.croppedRatio, 0), 1) : 0;

  useEffect(() => {
    /**
     * canvasRef.current check is important here as
     * parent component might not provide the canvas ref
     * if it renders the <img> element instead of <canvas>.
     * Meaning no significant work should be done by this hook.
     */
    if (theme === null || canvasRef.current === null) {
      return;
    }

    const bezelConfig = DEVICE_BEZEL_CONFIGURATION_MAP[bezel];
    const imageSrc = findSrcForTheme(src, srcset, theme);
    const globalBackgroundColor = getGlobalBackgroundColor();

    Promise.all([
      loadImage(imageSrc),
      bezelConfig ? loadImage(bezelConfig.src) : Promise.resolve(null),
      bezelConfig ? loadImage(bezelConfig.maskSrc) : Promise.resolve(null),
    ]).then(
      ([img, bezelImg, maskImg]: [
        HTMLImageElement,
        HTMLImageElement,
        HTMLImageElement
      ]) => {
        const canvas = canvasRef.current;
        const ctx = canvas?.getContext("2d");
        const scratchCanvas = document.createElement("canvas");
        const scratchCtx = scratchCanvas.getContext("2d");

        if (!canvas || !ctx || !scratchCtx) {
          return;
        }

        const targetWidth = bezelImg.naturalWidth;
        const targetHeight = bezelImg.naturalHeight;
        const croppedTargetHeight =
          targetHeight * (1 - cropTopRatio - cropBottomRatio);

        const horizontalOffset = bezelConfig ? bezelConfig.horizontalOffset : 0;
        const verticalOffset = bezelConfig ? bezelConfig.verticalOffset : 0;

        scratchCanvas.width = targetWidth;
        scratchCanvas.height = targetHeight;
        canvas.width = targetWidth;
        canvas.height = croppedTargetHeight;

        scratchCtx.imageSmoothingEnabled = true;
        scratchCtx.imageSmoothingQuality = "high";
        ctx.imageSmoothingEnabled = true;
        ctx.imageSmoothingQuality = "high";

        scratchCtx.drawImage(
          img,
          0,
          0,
          img.naturalWidth,
          img.naturalHeight,
          horizontalOffset,
          verticalOffset,
          /**
           * Note that these parameters are not x and y coordinates,
           * but width and height values on the target canvas to use
           * to draw the image starting from the provided above position,
           * hence doubling of the bezel offsets.
           */
          targetWidth - horizontalOffset * 2,
          targetHeight - verticalOffset * 2
        );

        if (imageSrc === PLACEHOLDER_SRC && globalBackgroundColor) {
          scratchCtx.save();
          scratchCtx.globalCompositeOperation = "color";
          scratchCtx.fillStyle = globalBackgroundColor;
          scratchCtx.globalAlpha = 0.55;
          scratchCtx.fillRect(0, 0, targetWidth, targetHeight);
          scratchCtx.restore();
        }

        if (maskImg) {
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
          scratchCtx.globalCompositeOperation = "source-over";
        }

        if (bezelImg) {
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
        }

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
    );
    /**
     * TODO: Optimize the srcset dependency (array re-created on every render) to avoid unnecessary reloads
     */
  }, [src, theme, cropBottomRatio, cropTopRatio, srcset, canvasRef, bezel]);
}

function getGlobalBackgroundColor(): string {
  return getComputedStyle(window.document.documentElement).getPropertyValue(
    "--color-fill-1"
  );
}
