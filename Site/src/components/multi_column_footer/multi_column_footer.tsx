import { FooterColumn } from "./components/footer_column";
import styles from "./multi_column_footer.module.css";

interface MultiColumnFooterProps {
  appIcon: React.ReactNode;
  footnoteLeading?: React.ReactNode;
  footnoteTrailing?: React.ReactNode;
  children?: React.ReactNode;
}

export function MultiColumnFooter({
  appIcon,
  children,
  footnoteLeading,
  footnoteTrailing,
}: MultiColumnFooterProps) {
  return (
    <footer className={styles.multiColumnFooter}>
      <div className={styles.main}>
        <div className={styles.appIcon} aria-hidden="true">{appIcon}</div>
        <div className={styles.linkColumns}>{children}</div>
      </div>
      <div className={styles.footnotes}>
        <div className={styles.footnoteLeading}>{footnoteLeading}</div>
        <div className={styles.footnoteTrailing}>{footnoteTrailing}</div>
      </div>
    </footer>
  );
}

MultiColumnFooter.Column = FooterColumn;
