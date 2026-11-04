"use client";

import { THEME } from "@/constants";
import { ClientRuntimeThemeContext } from "@/contexts/client_runtime_theme_context";
import type { ClientRuntimeTheme } from "@/types/shared";
import { useEffect, useState } from "react";

export function ThemeProvider({ children }: { children: React.ReactNode }) {
  const [theme, setTheme] = useState<ClientRuntimeTheme | null>(null);

  useEffect(() => {
    if (THEME !== "system") {
      setTheme(THEME);
      return;
    }

    const mediaQuery = window.matchMedia("(prefers-color-scheme: dark)");
    const handler = (event: MediaQueryListEvent) => {
      setTheme(event.matches ? "dark" : "light");
    };

    setTheme(mediaQuery.matches ? "dark" : "light");

    mediaQuery.addEventListener("change", handler);

    return () => {
      mediaQuery.removeEventListener("change", handler);
    };
  }, []);

  return (
    <ClientRuntimeThemeContext.Provider value={theme}>
      {children}
    </ClientRuntimeThemeContext.Provider>
  );
}
