import styles from "./compact_footer.module.css";

interface CompactFooterProps {
  appIcon: React.ReactNode;
  links: { label: string; href: string, external?: boolean }[];
  footnoteLeading?: React.ReactNode;
  footnoteTrailing?: React.ReactNode;
}

export function CompactFooter({
  appIcon,
  links,
  footnoteLeading,
  footnoteTrailing,
}: CompactFooterProps) {
  return (
    <footer className={styles.compactFooter}>
      <div className={styles.main}>
        <div className={styles.appIcon} aria-hidden="true">{appIcon}</div>
        <div className={styles.links}>
          <ul className={styles.links}>
            {links.map((link) => (
              <li key={link.href}>
                <a
                  href={link.href}
                  className={styles.link}
                  target={link.external ? "_blank" : "_self"}
                  rel={link.external ? "noopener noreferrer" : undefined}
                >
                  {link.label}
                </a>
              </li>
            ))}
          </ul>
        </div>
      </div>
      <div className={styles.footnotes}>
        <div className={styles.footnoteLeading}>{footnoteLeading}</div>
        <div className={styles.footnoteTrailing}>{footnoteTrailing}</div>
      </div>
    </footer>
  );
}
