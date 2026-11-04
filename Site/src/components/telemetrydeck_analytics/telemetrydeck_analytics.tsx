"use client";

import type { TelemetryDeckOptions } from "@telemetrydeck/sdk";
import { usePathname } from "next/navigation";
import { useEffect, useRef } from "react";
import { useTelemetryDeck } from "@/hooks/useTelemetryDeck";

export function TelemetryDeckAnalytics({
  appID,
  clientUser,
  target,
  sessionID,
  salt,
  testMode,
  store,
  subtleCrypto,
}: TelemetryDeckOptions) {
  const pathname = usePathname();
  const lastTrackedPathRef = useRef<string | null>(null);
  const telemetryDeck = useTelemetryDeck({
    appID,
    clientUser,
    target,
    sessionID,
    salt,
    testMode,
    store,
    subtleCrypto,
  });

  useEffect(() => {
    if (!pathname) {
      return;
    }

    if (lastTrackedPathRef.current === pathname) {
      return;
    }

    lastTrackedPathRef.current = pathname;

    telemetryDeck.signal("pageView", { path: pathname }).catch((error) => {
      console.error("TelemetryDeck page view tracking failed", error);
    });
  }, [pathname, telemetryDeck]);

  return null;
}
