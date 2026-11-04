import { readdir } from "node:fs/promises";
import path from "node:path";
import type { ComponentType } from "react";

type ReleaseNoteFileNameInfo = {
  fileName: string;
  slug: string;
  publishDate: Date;
};

type ReleaseNoteFrontmatterMetadata = {
  title: string;
  draft?: boolean;
};

type ReleaseNote = {
  content: ComponentType;
  title: string;
  publishDate: Date;
  slug: string;
  draft?: boolean;
};

const RELEASE_NOTE_FILENAME = /^(\d{4})-(\d{2})-(\d{2})-(.+)\.(md|mdx)$/i;

function parseReleaseNoteFileName(fileName: string) {
  const match = RELEASE_NOTE_FILENAME.exec(fileName);

  if (match === null) {
    console.warn(
      `\n${fileName} doesn't match filename format for a release note: YYYY-MM-DD-slug.(md|mdx)\n`
    );
    return null;
  }

  const [, year, month, day, slug] = match;
  const publishDate = new Date(`${year}-${month}-${day}`);

  if (Number.isNaN(publishDate.getTime())) {
    return null;
  }

  return {
    fileName,
    slug,
    publishDate,
  };
}

function guardFrontmatterMetadata(
  metadata: unknown
): metadata is ReleaseNoteFrontmatterMetadata {
  return (
    typeof metadata === "object" &&
    metadata !== null &&
    "title" in metadata &&
    typeof metadata.title === "string" &&
    ("draft" in metadata ? typeof metadata.draft === "boolean" : true)
  );
}

export async function readReleaseNoteFileInfoList(): Promise<
  ReleaseNoteFileNameInfo[]
> {
  const contentFolderPath = path.resolve(
    process.cwd(),
    "./app/(main)/release-notes/content"
  );

  return (await readdir(contentFolderPath))
    .map((fileName) => parseReleaseNoteFileName(fileName))
    .filter((entry) => entry !== null)
    .sort((a, b) => b.publishDate.getTime() - a.publishDate.getTime());
}

export async function readTotalReleaseNotesPageCount(
  notesPerPage: number
): Promise<number> {
  const fileNameInfoList = await readReleaseNoteFileInfoList();

  return Math.ceil(fileNameInfoList.length / notesPerPage);
}

/**
 * Loads a page of release note files from a directory by filename date prefix.
 * File names must follow: YYYY-MM-DD-title.(md|mdx)
 */
export async function readReleaseNotesPage(
  page: number,
  notesPerPage: number
): Promise<ReleaseNote[]> {
  const fileNameInfoList = await readReleaseNoteFileInfoList();
  const start = Math.max(0, page - 1) * notesPerPage;
  const pageFiles = fileNameInfoList.slice(start, start + notesPerPage);

  return Promise.all(
    pageFiles.map(async (file) => {
      const noteModule = await import(`@/content/${file.fileName}`);
      let frontmatterMetadata: ReleaseNoteFrontmatterMetadata;

      if (guardFrontmatterMetadata(noteModule.metadata)) {
        frontmatterMetadata = noteModule.metadata;
      } else {
        console.warn(`%{file.fileName} has invalid frontmatter metadata. Supported properties are: title (string), draft (optional, boolean)`);
        frontmatterMetadata = { title: "", draft: true };
      }

      return {
        content: noteModule.default,
        title: frontmatterMetadata.title,
        slug: file.slug,
        publishDate: file.publishDate,
        draft: frontmatterMetadata.draft,
      };
    })
  );
}
