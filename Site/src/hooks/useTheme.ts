import { ClientRuntimeThemeContext } from "@/contexts/client_runtime_theme_context";
import type { ClientRuntimeTheme } from "@/types/shared";
import { useContext } from "react";

export function useTheme(): ClientRuntimeTheme | null {
  return useContext(ClientRuntimeThemeContext);
}
