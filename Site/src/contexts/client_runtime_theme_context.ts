import { createContext } from "react";
import type { ClientRuntimeTheme } from "../types/shared";

export const ClientRuntimeThemeContext = createContext<ClientRuntimeTheme | null>(null);
