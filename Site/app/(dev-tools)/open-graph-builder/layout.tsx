import { ThemeStyle } from "@/components/theme_style/theme_style";
import { THEME } from "@/constants";
import "@/global.css";
import type { Metadata } from "next";
import { notFound } from "next/navigation";
import { OPEN_GRAPH_BUILDER_THEME_ROOT_CONTAINER_CLASSNAME } from "./components/open_graph_preview/open_graph_preview";

export const metadata: Metadata = {
  title: "Open Graph Generator - Dev Tool",
  description:
    "Internal tool for generating Open Graph image visible when your app's website is shared on social media.",
  metadataBase: new URL("http://localhost:3000"),
};

export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  if (process.env.NODE_ENV === "production") {
    notFound();
  }

  return (
    <html lang="en" data-theme={THEME}>
      <head>
        <ThemeStyle
          themeRootContainer={`.${OPEN_GRAPH_BUILDER_THEME_ROOT_CONTAINER_CLASSNAME}`}
        />
      </head>
      <body>{children}</body>
    </html>
  );
}
