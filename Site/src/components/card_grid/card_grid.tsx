import type { CSSProperties, ReactNode } from "react";
import styles from "./card_grid.module.css";
import { IconCard } from "./components/icon_card/icon_card";
import { OverlaidCard } from "./components/overlaid_card/overlaid_card";
import { StackedCard } from "./components/stacked_card/stacked_card";

type CardGridStyle = CSSProperties & Record<"--card-height", string | number>;

interface CardGridProps {
	children: ReactNode;
	rowHeight?: number;
}

export function CardGrid({ children, rowHeight = 438 }: CardGridProps) {
	const gridStyle: CardGridStyle = {
		"--card-height": `${rowHeight}px`,
	};

	return (
		<div className={styles.cardGrid} style={gridStyle}>
			{children}
		</div>
	);
}

CardGrid.StackedCard = StackedCard;
CardGrid.OverlaidCard = OverlaidCard;
CardGrid.IconCard = IconCard;
