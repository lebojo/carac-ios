import { Article } from "../article/article";
import styles from "./release_note.module.css";

interface ReleaseNoteProps {
  title: string;
  publishDate: Date;
  content: React.ReactNode;
}

export function ReleaseNote({ title, publishDate, content }: ReleaseNoteProps) {
  const formattedDate = publishDate.toLocaleDateString(undefined, {
    year: "numeric",
    month: "long",
    day: "numeric",
  });

  return (
    <Article className={styles.releaseNote}>
      <span className={styles.publishDate}>{formattedDate}</span>
      <h1 className={styles.title}>{title}</h1>
      {content}
    </Article>
  );
}
