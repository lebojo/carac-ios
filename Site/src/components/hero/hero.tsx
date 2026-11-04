import { buildClassNameForFontStyle } from "@/lib/utils";
import type { FontStyle } from "@/types/shared";
import { HeroImage } from "./components/hero_image/hero_image";
import { HeroVideo } from "./components/hero_video/hero_video";
import styles from "./hero.module.css";

interface HeroProps {
  title: string;
  subtitle: string;
  titleFontStyle?: FontStyle;
  badges?: React.ReactNode;
  media: React.ReactNode;
  action?: React.ReactNode;
}

export function Hero({
  title,
  subtitle,
  titleFontStyle = "sans",
  badges,
  media,
  action,
}: HeroProps) {
  const titleFontStyleClass = buildClassNameForFontStyle(titleFontStyle, {
    whimsical: styles.whimsical,
    cursive: styles.cursive,
  });

  return (
    <div className={styles.hero}>
      <div className={styles.content}>
        {badges && <div className={styles.badges}>{badges}</div>}

        <h1 className={`${styles.title} ${titleFontStyleClass}`}>{title}</h1>
        <p className={styles.subtitle}>{subtitle}</p>

        {action && <div className={styles.action}>{action}</div>}
      </div>
      <div className={styles.media}>{media}</div>
    </div>
  );
}

Hero.Image = HeroImage;
Hero.Video = HeroVideo;
