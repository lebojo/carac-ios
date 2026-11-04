import styles from "./article.module.css";

interface ArticleProps {
  className?: string;
  children: React.ReactNode;
}

export function Article({ className, children }: ArticleProps) {
  return (
    <article className={`${styles.article} ${className ?? ""}`}>
      {children}
    </article>
  );
}
