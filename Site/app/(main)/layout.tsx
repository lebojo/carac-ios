import { APP_ID, IS_WAITLIST_ENABLED, THEME } from "@/constants";
import type { Metadata, Viewport } from "next";

import { AppIcon } from "@/components/app_icon/app_icon";
import { CompactFooter } from "@/components/compact_footer/compact_footer";
import { DownloadActionButton } from "@/components/download_action_button/download_action_button";
import { MaterialSymbolsLink } from "@/components/material_symbols_link/material_symbols_link";
import { Navbar } from "@/components/navbar/navbar";
import { ThemeStyle } from "@/components/theme_style/theme_style";
import { publicPath } from "@/lib/public_path";
import "@/global.css";
import { ThemeProvider } from "@/providers/theme_provider";

const SITE_URL = process.env.NEXT_PUBLIC_SITE_URL || "https://carac.jordan-chap.com/";

const DESCRIPTION = "Carac is a free strength training log for iPhone and iPad. Plan your trainings by weekday, log every set in seconds and watch your progress.";

export const metadata: Metadata = {
  /**
   * `title` and `description` are visible in search results.
   * Recommended length for title is max 60 characters.
   * Recommended length for description is max 160 characters.
   */
  title: "Carac | Plan, log and track your lifts",
  description: DESCRIPTION,

  /**
   * Your website URL.
   */
  metadataBase: new URL(SITE_URL),

  /**
   * Info inside `openGraph` and `twitter` is used to show rich previews
   * on social media when someone shares a link to your website.
   *
   * AppView comes with a tool to help you generate an Open Graph image,
   * run the dev server and go to `http://localhost:3000/open-graph-builder`.
   */
  openGraph: {
    title: "Carac",
    description: DESCRIPTION,
    url: SITE_URL,
    images: [
      {
        url: publicPath("/og-preview.png"),
        width: 1280,
        height: 720,
        alt: "Carac, a strength training log for iPhone and iPad",
      },
    ],
    type: "website",
  },
  twitter: {
    card: "summary_large_image",
    title: "Carac",
    description: DESCRIPTION,
    images: [publicPath("/og-preview.png")],
  },
};

export const viewport: Viewport = {
  width: "device-width",
  initialScale: 1.0,
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en" data-theme={THEME}>
      <head>
        {/* This makes Safari on iOS show the App Store download banner */}
        {!IS_WAITLIST_ENABLED && APP_ID !== null && (
          <meta name="apple-itunes-app" content={`app-id=${APP_ID}`} />
        )}

        <link rel="icon" href={publicPath("/favicon.png")} type="image/png" sizes="48x48" />

        <ThemeStyle />
        <MaterialSymbolsLink />
      </head>
      <body>
        <ThemeProvider>
          {!IS_WAITLIST_ENABLED && (
            <Navbar
              icon={<AppIcon src={publicPath("/app-icon.png")} />}
              appName="Carac"
              links={[
                { label: "Features", href: "#features" },
                { label: "Release Notes", href: "/release-notes" },
                { label: "Developer", href: "https://jordan-chap.com", external: true },
              ]}
              action={<DownloadActionButton />}
            />
          )}

          {children}

          {/*
            There is also a <MultiColumnFooter> component available
            in case you need more space for links.
          */}
          <CompactFooter
            appIcon={<AppIcon src={publicPath("/app-icon.png")} />}
            links={[
              { label: "Privacy Policy", href: "/policy" },
              { label: "Terms of Use", href: "/terms" },
              { label: "Release Notes", href: "/release-notes" },
              {
                label: "Source Code",
                href: "https://github.com/lebojo/carac-ios",
                external: true,
              },
              { label: "Developer", href: "https://jordan-chap.com", external: true },
            ]}
            footnoteLeading={`© ${new Date().getFullYear()} Jordan Chapelle.`}
            footnoteTrailing={
              // I'd appreciate if you leave this link here, but feel free to remove it, no hard feelings :)
              <>
                Website is built with{" "}
                <a target="_blank" href="https://appview.dev">
                  AppView
                </a>
              </>
            }
          />
        </ThemeProvider>

        {/* <PlausibleAnalytics domain="your-app-domain.com" /> */}
        {/* <TelemetryDeckAnalytics appID="your-telemetrydeck-app-id" clientUser="anonymous" /> */}
        {/* <VercelAnalytics /> */}
      </body>
    </html>
  );
}
