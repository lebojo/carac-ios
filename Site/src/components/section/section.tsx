import styles from "./section.module.css";

interface SectionProps {
  title?: string;
  children?: React.ReactNode;
  navigationAnchor?: string;
  paddingTop?: number;
  paddingBottom?: number;
}

export function Section({ title, children, navigationAnchor, paddingTop, paddingBottom }: SectionProps) {
  return (
    <section className={styles.section} id={navigationAnchor} style={{ paddingTop, paddingBottom }}>
      {title && <h2 className={styles.title}>{title}</h2>}
      {children}
    </section>
  );
}
