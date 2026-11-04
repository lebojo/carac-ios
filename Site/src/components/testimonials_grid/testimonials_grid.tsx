import { Testimonial } from "./components/testimonial/testimonial";
import styles from "./testimonials_grid.module.css";

interface TestimonialsGridProps {
  children?: React.ReactNode;
  maxColumnCount?: number;
}

export function TestimonialsGrid({
  children,
  maxColumnCount = 2,
}: TestimonialsGridProps) {
  return (
    <div
      className={styles.testimonialsGrid}
      style={{ "--column-count": maxColumnCount } as React.CSSProperties}
    >
			{children}
    </div>
  );
}

TestimonialsGrid.Testimonial = Testimonial;
