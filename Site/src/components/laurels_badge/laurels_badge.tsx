import Laurel from "@/public/app_view/laurel.svg";
import styles from "./laurels_badge.module.css";

interface LaurelsBadgeProps {
	children: React.ReactNode;
	ariaLabel?: string;
	header?: React.ReactNode;
	caption?: string;
}

export function LaurelsBadge({
	children,
	header = <></>,
	caption = "",
	ariaLabel = ""
}: LaurelsBadgeProps) {
	return (
		<figure
			className={styles.laurelsBadge}
			aria-label={ariaLabel}
		>
			{<div className={styles.header}>{header}</div>}

			<div className={styles.laurelsWrap}>
				<div className={styles.laurelLeading}>
					<Laurel width={18} height={37} />
				</div>
				<div className={styles.badgeValue}>{children}</div>
				<div className={styles.laurelTrailing}>
					<Laurel width={18} height={37} />
				</div>
			</div>

			{<div className={styles.caption}>{caption}</div>}
		</figure>
	);
}
