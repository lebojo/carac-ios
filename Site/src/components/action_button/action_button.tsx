import { MATERIAL_SYMBOLS } from "@/constants";
import { Icon } from "../icon/icon";
import styles from "./action_button.module.css";

interface ActionButtonProps {
  href: string;
  iconName: (typeof MATERIAL_SYMBOLS)[number];
  label?: string;
  size?: "small" | "medium" | "large";
}

export function ActionButton({
  href,
  iconName,
  label = "Download",
  size = "medium",
}: ActionButtonProps) {
  return (
    <a href={href} className={`${styles.actionButton} ${styles[size]}`} target="_blank">
      <div className={styles.label}>
        <Icon name={iconName} size={size} />
        <div className={styles.actionLabel}>{label}</div>
      </div>
    </a>
  );
}
