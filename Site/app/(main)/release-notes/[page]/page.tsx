import type { Metadata } from "next";

import { ReleaseNote } from "@/components/release_note/release_note";
import { ReleaseNotesPagination } from "@/components/release_notes_pagination/release_notes_pagination";
import { MAX_RELEASE_NOTES_PER_PAGE } from "@/constants";
import {
  readReleaseNotesPage,
  readTotalReleaseNotesPageCount,
} from "@/lib/release_notes_helpers";

export const metadata: Metadata = {
  title: "Release Notes | Carac",
  description: "What's new in each version of Carac.",
};

export default async function ReleaseNotesPage({
  params,
}: {
  params: Promise<{ page: string }>;
}) {
  const { page } = await params;
  const totalPageCount = await readTotalReleaseNotesPageCount(
    MAX_RELEASE_NOTES_PER_PAGE,
  );
  const notes = await readReleaseNotesPage(
    Number(page),
    MAX_RELEASE_NOTES_PER_PAGE,
  );

  return (
    <>
      {notes.map((note) => (
        <ReleaseNote
          key={note.slug}
          title={note.title}
          publishDate={note.publishDate}
          content={<note.content />}
        />
      ))}

      {totalPageCount > 1 && (
        <ReleaseNotesPagination
          currentPage={Number(page)}
          totalPageCount={totalPageCount}
        />
      )}
    </>
  );
}

export async function generateStaticParams() {
  const totalPageCount = await readTotalReleaseNotesPageCount(
    MAX_RELEASE_NOTES_PER_PAGE,
  );

  return Array.from({
    length: totalPageCount,
  }).map((_, index) => ({
    page: String(index + 1),
  }));
}

export const dynamicParams = false;
