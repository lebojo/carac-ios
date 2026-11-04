import { buildClassNameForFontStyle } from "@/lib/utils";
import type { FontStyle } from "@/types/shared";
import sharedGridStyles from "../../shared.module.css";
import { StackedCardImage } from "./components/stacked_card_image/stacked_card_image";
import { StackedCardVideo } from "./components/stacked_card_video/stacked_card_video";
import styles from "./stacked_card.module.css";

interface StackedCardProps {
  maxWidth: "third" | "half" | "twoThirds" | "full";
  title: string;
  titleFontStyle?: FontStyle;
  description?: string;
  media: React.ReactNode;
  textAlignment?: "leading" | "center" | "trailing";
  layoutDirection?: "forward" | "reverse";
}

export function StackedCard({
  maxWidth,
  title,
  titleFontStyle = "sans",
  description,
  media,
  textAlignment = "leading",
  layoutDirection = "forward",
}: StackedCardProps) {
  const titleFontStyleClass = buildClassNameForFontStyle(titleFontStyle, {
    whimsical: styles.whimsical,
    cursive: styles.cursive,
  });

  return (
    <figure
      className={`${sharedGridStyles.gridCardItem} ${sharedGridStyles[maxWidth]}`}
    >
      <div className={`${styles.content} ${styles[layoutDirection]}`}>
        <div className={styles.media}>{media}</div>
        <div
          className={`${styles.text} ${styles[layoutDirection]} ${styles[textAlignment]}`}
        >
          <div className={`${styles.textContent}`}>
            <h2 className={`${styles.title} ${titleFontStyleClass}`}>
              {title}
            </h2>
            <p className={styles.description}>{description}</p>
          </div>
        </div>
      </div>
    </figure>
  );
}

StackedCard.Image = StackedCardImage;
StackedCard.Video = StackedCardVideo;
