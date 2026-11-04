import type {
	ClientRuntimeTheme,
	FontStyle,
	ImageSrcsetEntry,
} from "../types/shared";
import { CURSIVE_FONT, WHIMSICAL_FONT } from "../constants";
import { publicPath } from "./public_path";

function resolvePublicSrc(src: string): string {
	const basePath = process.env.NEXT_PUBLIC_BASE_PATH || "";
	return src.startsWith("/") && !src.startsWith(`${basePath}/`) ? publicPath(src) : src;
}

export function findSrcForTheme(
	src: string,
	srcset: ImageSrcsetEntry[] | undefined,
	theme: ClientRuntimeTheme,
): string {
	const targetSrcsetEntry = srcset?.find((entry) => entry.theme === theme);

	if (targetSrcsetEntry === undefined) {
		return src;
	}

	return targetSrcsetEntry.src;
}

export function buildClassNameForFontStyle(
	fontStyle: FontStyle,
	extraClassName: Partial<Record<FontStyle, string>> = {
		sans: "",
		mono: "",
		rounded: "",
		whimsical: "",
		cursive: "",
	},
): string {
	switch (fontStyle) {
		case "sans":
			return `${extraClassName.sans}`;
		case "mono":
			return `monoFont ${extraClassName.mono}`;
		case "rounded":
			return `roundedFont ${extraClassName.rounded}`;
		case "whimsical":
			return `whimsicalFont ${WHIMSICAL_FONT.className} ${extraClassName.whimsical}`;
		case "cursive":
			return `cursiveFont ${CURSIVE_FONT.className} ${extraClassName.cursive}`;
		default:
			return "";
	}
}

export function loadImage(src: string): Promise<HTMLImageElement> {
	return new Promise((resolve, reject) => {
		const img = new Image();
		img.src = resolvePublicSrc(src);

		img.onload = () => resolve(img);
		img.onerror = () => reject(new Error(`Failed to load image: ${src}`));
	});
}

export function loadVideo(src: string): Promise<HTMLVideoElement> {
	return new Promise((resolve, reject) => {
		const video = document.createElement("video");

		video.crossOrigin = "anonymous";
		video.muted = true;
		video.loop = true;
		video.playsInline = true;
		video.preload = "auto";

		function cleanup() {
			video.removeEventListener("loadeddata", handleLoadedData);
			video.removeEventListener("error", handleError);
		}

		function handleLoadedData() {
			cleanup();
			resolve(video);
		}

		function handleError() {
			cleanup();
			reject(new Error(`Failed to load video: ${src}`));
		}

		video.addEventListener("loadeddata", handleLoadedData);
		video.addEventListener("error", handleError);
		video.src = resolvePublicSrc(src);
		video.load();
	});
}
