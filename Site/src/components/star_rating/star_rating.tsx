import { Icon } from "../icon/icon";
import styles from "./star_rating.module.css";

interface StarRatingProps {
  rating: number;
  starSize?: number;
}

export function StarRating({ rating, starSize = 16 }: StarRatingProps) {
  const starCount = Math.round(rating);

  return (
    <div className={styles.starRating}>
      {Array.from({ length: starCount }).map((_, index) => (
        <Icon key={index} name="star" size={starSize} />
      ))}
    </div>
  );
}
