"use client";

import TelemetryDeck, { type TelemetryDeckOptions } from "@telemetrydeck/sdk";
import { useMemo } from "react";

export function useTelemetryDeck({
  appID,
  clientUser,
  target,
  sessionID,
  salt,
  testMode,
  store,
  subtleCrypto,
}: TelemetryDeckOptions): TelemetryDeck {
  return useMemo(
    () =>
      new TelemetryDeck({
        appID,
        clientUser,
        target,
        sessionID,
        salt,
        testMode,
        store,
        subtleCrypto,
      }),
    [appID, clientUser, target, sessionID, salt, testMode, store, subtleCrypto],
  );
}
