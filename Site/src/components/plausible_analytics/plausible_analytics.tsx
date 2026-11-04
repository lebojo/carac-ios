"use client";

import type { PlausibleConfig } from "@plausible-analytics/tracker";
import { useEffect } from "react";

export function PlausibleAnalytics(props: PlausibleConfig) {
  useEffect(() => {
    const overrideProps: Partial<PlausibleConfig> = {
      bindToWindow: false
    };

    import("@plausible-analytics/tracker").then(({ init }) =>
      init({ ...props, ...overrideProps })
    );
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, []);

  return null;
}
