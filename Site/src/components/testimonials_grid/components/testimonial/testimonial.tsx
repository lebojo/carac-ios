"use client";

import { Icon } from "@/components/icon/icon";
import { StarRating } from "@/components/star_rating/star_rating";
import { useTheme } from "@/hooks/useTheme";
import Image from "next/image";
import styles from "./testimonial.module.css";

import AppStoreLogo from "@/public/app_view/appstore_logo.svg";
import BlueskyLogo from "@/public/app_view/bluesky_logo.svg";
import InstagramLogo from "@/public/app_view/instagram_logo.svg";
import MastodonLogo from "@/public/app_view/mastodon_logo.svg";
import RedditLogo from "@/public/app_view/reddit_logo.svg";
import ThreadsLogo from "@/public/app_view/threads_logo.svg";
import XLogo from "@/public/app_view/x_logo.svg";
import YoutubeLogo from "@/public/app_view/youtube_logo.svg";

type SourceKind = "appStore" | string;

interface TestimonialProps {
  message: string;
  authorName: string;
  authorTitle?: string;
  authorImageUrl?: string;
  messageFontStyle?: "normal" | "italic";
  quotationMarks?: boolean;
  source?: SourceKind;
  starsRating?: boolean;
}

export function Testimonial({
  message,
  authorName,
  authorTitle,
  authorImageUrl,
  messageFontStyle = "italic",
  quotationMarks = true,
  source,
  starsRating = false,
}: TestimonialProps) {
  return (
    <figure className={styles.testimonial}>
      {starsRating && (
        <div className={styles.rating} aria-label="5 star rating" role="img">
          <StarRating rating={5} starSize={18} />
        </div>
      )}

      <blockquote
        className={`${styles.message} ${
          messageFontStyle === "italic" ? styles.messageItalic : ""
        } ${quotationMarks ? styles.quotationMarks : ""}`}
      >
        {`${message}${quotationMarks ? "”" : ""}`}
      </blockquote>
      <div className={styles.footer}>
        <figcaption className={styles.author}>
          <div className={styles.authorName}>{authorName}</div>
          {authorTitle && (
            <div className={styles.authorTitle}>{authorTitle}</div>
          )}
          {authorImageUrl && (
            <div className={styles.authorImage}>
              <Image
                src={authorImageUrl}
                alt={authorName}
                width={40}
                height={40}
              />
            </div>
          )}
        </figcaption>

        {source && (
          <div className={styles.source}>
            <TestimonialSource source={source} />
          </div>
        )}
      </div>
    </figure>
  );
}

function TestimonialSource({ source }: { source: SourceKind }) {
  const theme = useTheme();

  if (theme === null) {
    return null;
  }

  const logoSize = 26;

  if (source === "appStore") {
    return (
      <AppStoreLogo
        className={styles.sourceLogo}
        width={logoSize}
        height={logoSize}
      />
    );
  }

  const matchedSource = source.match(/^(?:https?:\/\/)?(?:www\.)?([^\/\s:]+)/);

  if (!matchedSource) {
    return null;
  }

  let sourceLogo: React.ReactNode = null;

  switch (matchedSource[1].toLowerCase()) {
    case "x.com":
      sourceLogo = (
        <XLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "reddit.com":
      sourceLogo = (
        <RedditLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "threads.com":
      sourceLogo = (
        <ThreadsLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "youtube.com":
      sourceLogo = (
        <YoutubeLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "mastodon.social":
      sourceLogo = (
        <MastodonLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "bsky.app":
      sourceLogo = (
        <BlueskyLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    case "instagram.com":
      sourceLogo = (
        <InstagramLogo
          className={styles.sourceLogo}
          width={logoSize}
          height={logoSize}
        />
      );
      break;
    default:
      sourceLogo = "";
  }

  return (
    <a
      href={source}
      className={styles.sourceLink}
      target="_blank"
      rel="noopener noreferrer"
    >
      {sourceLogo === "" ? (
        <div className={styles.sourceLogo}>
          <Icon name="open_in_new" size="medium" />
        </div>
      ) : (
        sourceLogo
      )}
    </a>
  );
}
