import { MATERIAL_SYMBOLS } from "@/constants";

export function MaterialSymbolsLink() {
  const iconNames = MATERIAL_SYMBOLS.toSorted().join(",");

  return (
    <link
      rel="stylesheet"
      href={`https://fonts.googleapis.com/css2?family=Material+Symbols+Rounded:opsz,wght,FILL,GRAD@30,600,0..1,0&icon_names=${iconNames}`}
    />
  );
}
