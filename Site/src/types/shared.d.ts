export type ClientRuntimeTheme = "light" | "dark";

export interface BezelConfiguration {
  src: string;
  maskSrc: string;
  horizontalOffset: number;
  verticalOffset: number;
  shadowBottomOffset: number;
}

export type BezelCropConfiguration = {
  edge: "top" | "bottom";
  croppedRatio: number;
};

export interface ImageSrcsetEntry {
  src: string;
  theme: ClientRuntimeTheme;
}

export type Bezel =
  | "iPhone 17 Black"
  | "iPhone 17 Lavender"
  | "iPhone 17 Mist Blue"
  | "iPhone 17 Sage"
  | "iPhone 17 White"
  | "iPhone 17 Pro Cosmic Orange"
  | "iPhone 17 Pro Deep Blue"
  | "iPhone 17 Pro Silver"
  | "iPhone Air Cloud White"
  | "iPhone Air Sky Blue"
  | "iPhone Air Light Gold"
  | "iPhone Air Space Black"
  | "iPhone 18 Pro Black"
  | "iPhone 18 Pro Burgundy"
  | "iPhone 18 Pro Glacier"
  | "iPhone 18 Pro Silver";

export type FontStyle = "sans" | "mono" | "rounded" | "whimsical" | "cursive";

export type ThemeColorKey =
  | "text-primary"
  | "text-secondary"
  | "fill-0"
  | "fill-1"
  | "fill-2"
  | "fill-3"
  | "accent-brand"
  | "accent-orange"
  | "accent-green"
  | "accent-red"
  | "accent-blue"
  | "accent-indigo"
  | "accent-mint"
  | "accent-purple"
  | "accent-pink";

export type ColorScheme = {
  LIGHT: Record<ThemeColorKey, string>;
  DARK: Record<ThemeColorKey, string>;
};
