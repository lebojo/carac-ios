import { Article } from "@/components/article/article";

export default function PolicyPageLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <Article>{children}</Article>;
}
