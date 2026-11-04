import { DOWNLOAD_SHORT_LABEL, DOWNLOAD_URL } from "@/constants";
import AppleLogo from "@/public/app_view/apple_logo.svg";
import styles from "./download_action_button.module.css";

interface DownloadActionButtonProps {
  href?: string;
  label?: string;
  size?: "small" | "medium" | "large";
  /** Shows only the store logo on compact screens */
  collapsesLabel?: boolean;
}

export function DownloadActionButton({
  href,
  label = DOWNLOAD_SHORT_LABEL,
  size = "small",
  collapsesLabel = false,
}: DownloadActionButtonProps) {
  let appleLogoSize;

  switch (size) {
    case "small":
      appleLogoSize = 18;
      break;
    case "medium":
      appleLogoSize = 20;
      break;
    case "large":
      appleLogoSize = 24;
      break;
    default:
      appleLogoSize = 18;
  }

  return (
    <a
      href={href ?? DOWNLOAD_URL}
      className={`${styles.downloadActionButton} ${styles[size]} ${collapsesLabel ? styles.collapsesLabel : ""}`}
      target="_blank"
      aria-label={collapsesLabel ? label : undefined}
    >
      <div className={styles.label}>
        <div className={styles.appleLogo}>
          <AppleLogo width={appleLogoSize} height={appleLogoSize} />
        </div>
        <div className={styles.downloadLabel}>{label}</div>
      </div>
    </a>
  );
}
