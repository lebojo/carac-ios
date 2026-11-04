import { Icon } from "@/components/icon/icon";
import type { MATERIAL_SYMBOLS } from "@/constants";
import { buildClassNameForFontStyle } from "@/lib/utils";
import type { FontStyle } from "@/types/shared";
import sharedGridStyles from "../../shared.module.css";
import styles from "./icon_card.module.css";

interface IconCardProps {
  maxWidth: "third" | "half" | "twoThirds" | "full";
  iconName: (typeof MATERIAL_SYMBOLS)[number];
  title: string;
  titleFontStyle?: FontStyle;
  description?: string;
}

export function IconCard({
  maxWidth,
  iconName,
  title,
  titleFontStyle,
  description,
}: IconCardProps) {
  const titleFontStyleClass = buildClassNameForFontStyle(titleFontStyle, {
    whimsical: styles.whimsical,
    cursive: styles.cursive,
  });

  return (
    <figure
      className={`${sharedGridStyles.gridCardItem} ${sharedGridStyles[maxWidth]}`}
    >
      <div className={styles.iconCard}>
        <div className={styles.icon} aria-hidden="true">
          <Icon name={iconName} size="large" />
        </div>
        <div className={styles.info}>
          <h2 className={`${styles.title} ${titleFontStyleClass}`}>{title}</h2>
          <p className={styles.description}>{description}</p>
        </div>
      </div>
    </figure>
  );
}
