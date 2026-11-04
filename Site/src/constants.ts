import { Caveat, Dancing_Script } from "next/font/google";
import { ColorScheme } from "./types/shared";

/**
 * "system" - follows the user's system appearance
 * "light" - forces your website to always use light theme
 * "dark" - forces your website to always use dark theme
 */
export const THEME: "system" | "light" | "dark" = "system";

/**
 * Your App Store App ID without the 'id' prefix.
 * You can find it in your App Store Connect.
 * Go to your app -> App Information -> Apple ID.
 *
 * Carac is not on the App Store yet: while this is `null`, every download
 * button points to the public TestFlight beta instead. Set it once the app
 * is live (example: "6502667826") and the buttons, labels and the Safari
 * App Store banner switch over automatically.
 */
export const APP_ID: string | null = null;

export const TESTFLIGHT_URL = "https://testflight.apple.com/join/cnudJaMH";

export const DOWNLOAD_URL =
  APP_ID === null ? TESTFLIGHT_URL : `https://apps.apple.com/app/id${APP_ID}`;

export const DOWNLOAD_LABEL =
  APP_ID === null ? "Join the beta on TestFlight" : "Download free on the App Store";

export const DOWNLOAD_SHORT_LABEL = APP_ID === null ? "TestFlight" : "App Store";

/**
 * Custom fonts for 'whimsical' and 'cursive' font styles.
 * Default system font is used for all other font styles.
 * See https://nextjs.org/docs/app/getting-started/fonts#google-fonts
 */
export const WHIMSICAL_FONT = Caveat({ subsets: ["latin"] });
export const CURSIVE_FONT = Dancing_Script({ subsets: ["latin"] });

export const MATERIAL_SYMBOLS = [
  "send",
  "check_circle",
  "star",
  "mail",
  "open_in_new",
  "open_in_full",
  "play_arrow",
  "pause",
  "lock",
  "target",
  "cloud_sync",
  "favorite",
  "save",
  "contrast",
  "translate",
] as const;

// Carac palette: the app's green AccentColor on a pale green tint (light) or black (dark)
export const COLORS: ColorScheme = {
  LIGHT: {
    "text-primary": "#111813",
    "text-secondary": "#56615A",
    "fill-0": "#FFFFFF",
    "fill-1": "#F3FAF5",
    "fill-2": "#E4F2E8",
    "fill-3": "#CFE5D6",
    "accent-brand": "#34C759",
    "accent-orange": "#FF8D28",
    "accent-green": "#34C759",
    "accent-red": "#FF3B30",
    "accent-blue": "#007AFF",
    "accent-indigo": "#5856D6",
    "accent-mint": "#00C7BE",
    "accent-purple": "#AF52DE",
    "accent-pink": "#FF2D55",
  },
  DARK: {
    "text-primary": "#FFFFFF",
    "text-secondary": "rgba(235, 235, 245, 0.60)",
    "fill-0": "#000000",
    "fill-1": "#000000",
    "fill-2": "#1C1C1E",
    "fill-3": "#2C2C2E",
    "accent-brand": "#30D158",
    "accent-orange": "#FF9230",
    "accent-green": "#30D158",
    "accent-red": "#FF453A",
    "accent-blue": "#0A84FF",
    "accent-indigo": "#5E5CE6",
    "accent-mint": "#63E6E2",
    "accent-purple": "#BF5AF2",
    "accent-pink": "#FF375F",
  },
} as const;

export const MAX_RELEASE_NOTES_PER_PAGE = 5;

export const IS_WAITLIST_ENABLED = false;
