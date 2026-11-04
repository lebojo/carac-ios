import { LaurelsBadge } from "@/components/laurels_badge/laurels_badge";
import AppleLogo from "@/public/app_view/apple_logo.svg";
import styles from "./apple_feature_laurels_badge.module.css";

interface AppleFeatureLaurelsBadgeProps {
  featureName: string;
}

export function AppleFeatureLaurelsBadge({
  featureName,
}: AppleFeatureLaurelsBadgeProps) {
  return (
    <LaurelsBadge
      header={
        <div className={styles.header} aria-hidden="true">
          <AppleLogo width={12} height={12} />
          Feature
        </div>
      }
      ariaLabel={`Apple feature badge showing feature name ${featureName}`}
    >
      <div className={styles.featureName}>{featureName}</div>
    </LaurelsBadge>
  );
}
