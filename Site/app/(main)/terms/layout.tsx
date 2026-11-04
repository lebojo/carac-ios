import { Article } from "@/components/article/article";

export default function TermsPageLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return <Article>{children}</Article>;
}
