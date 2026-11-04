import type { MATERIAL_SYMBOLS } from "@/constants";
import styles from "./icon.module.css";

interface IconProps {
  name: (typeof MATERIAL_SYMBOLS)[number];
  filled?: boolean;
  size?: "small" | "medium" | "large" | number;
}

export function Icon({ name, filled = true, size = "medium" }: IconProps) {
  const isCustomSize = typeof size === "number";

  return (
    <span
      className={`material-symbols-rounded ${styles.icon} ${
        filled ? styles.iconFilled : styles.iconOutlined
      } ${isCustomSize ? "" : styles[size]}`}
      style={isCustomSize ? { fontSize: size } : undefined}
    >
      {name}
    </span>
  );
}
