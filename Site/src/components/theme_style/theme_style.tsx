import { COLORS } from "@/constants";
import { ThemeColorKey } from "@/types/shared";
import chroma from "chroma-js";

interface ThemeStyleProps {
  themeRootContainer?: string;
}

export function ThemeStyle({ themeRootContainer = ":root" }: ThemeStyleProps) {
  return (
    <style>{`
      ${themeRootContainer},
      ${themeRootContainer}[data-theme="light"] {
        color-scheme: light;
        --color-scheme: light;
        ${buildColorThemeCSSVariables(COLORS.LIGHT)}
      }

      @media (prefers-color-scheme: dark) {
        ${themeRootContainer} {
          color-scheme: dark;
          --color-scheme: dark;
          ${buildColorThemeCSSVariables(COLORS.DARK)}
        }
      }

      ${themeRootContainer}[data-theme="dark"] {
        color-scheme: dark;
        --color-scheme: dark;
        ${buildColorThemeCSSVariables(COLORS.DARK)}
      }
    `}</style>
  );
}

function buildColorThemeCSSVariables(colors: Record<ThemeColorKey, string>) {
  return Object.entries(colors)
    .map(([key, value]) => {
      const chromaColor = chroma(value);
      const oklchColor = chromaColor.css("oklch");

      return `--color-${key}: ${oklchColor};`;
    })
    .concat(buildTextAccentBrandColorVariable(colors["accent-brand"]))
    .join("\n");
}

function buildTextAccentBrandColorVariable(accentBrandColor: string): string {
  const textAccentBrandColor = chroma(
    chroma(accentBrandColor).luminance() > 0.5 ? "black" : "white"
  );
  return `--color-text-accent-brand: ${textAccentBrandColor.css("oklch")};`;
}
