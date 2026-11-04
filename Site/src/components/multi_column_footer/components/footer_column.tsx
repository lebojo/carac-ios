import styles from "./footer_column.module.css";

interface FooterColumnProps {
  title: string;
  links: { label: string; href: string; external?: boolean }[];
}

export function FooterColumn({ title, links }: FooterColumnProps) {
  return (
    <div className={styles.footerColumn}>
      <div className={styles.title}>{title}</div>
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
  );
}
