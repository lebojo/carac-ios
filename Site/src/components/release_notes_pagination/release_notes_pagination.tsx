import Link from "next/link";
import styles from "./release_notes_pagination.module.css";

type ReleaseNotesPaginationProps = {
  currentPage: number;
  totalPageCount: number;
  basePath?: string;
};

function buildPageHref(page: number, basePath: string) {
  return page <= 1 ? basePath : `${basePath}/${page}`;
}

export function ReleaseNotesPagination({
  currentPage,
  totalPageCount,
  basePath = "/release-notes",
}: ReleaseNotesPaginationProps) {
  const newerDisabled = currentPage <= 1;
  const olderDisabled = currentPage >= totalPageCount;

  const newerHref = buildPageHref(currentPage - 1, basePath);
  const olderHref = buildPageHref(currentPage + 1, basePath);

  return (
    <nav className={styles.pagination} aria-label="Release notes pagination">
      <PaginationButton
        label="Older Notes"
        href={olderHref}
        disabled={olderDisabled}
      />
      <PaginationButton
        label="Newer Notes"
        href={newerHref}
        disabled={newerDisabled}
      />
    </nav>
  );
}

function PaginationButton({
  label,
  href,
  disabled,
}: {
  label: string;
  href: string;
  disabled: boolean;
}) {
  if (disabled) {
    return (
      <button className={styles.button} disabled>
        {label}
      </button>
    );
  }

  return (
    <Link href={href} className={styles.button}>
      {label}
    </Link>
  );
}
