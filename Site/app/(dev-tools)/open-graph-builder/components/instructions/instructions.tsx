import styles from "./instructions.module.css";

export function Instructions() {
  return (
    <article className={styles.instructions}>
      <p>
        This tool lets you quickly create a good looking Open Graph image for
        you app&apos;s website. Open Graph images are the previews that social
        media platforms show when someone shares a link.
      </p>

      <p>
        It&apos;s important to have these previews and make them look good as
        it&apos;s often the first thing new users see about your app.
      </p>

      <p>
        Above is the preview of your Open Graph image. Follow these steps to
        customize it and generate the final PNG.
      </p>

      <ol>
        <li>
          Open <code>app/(dev-tools)/open-graph-builder/page.tsx</code> file an
          customize parameters of the <code>&lt;OpenGraphPreview&gt;</code>{" "}
          component. The preview above will reflect all your changes.
        </li>
        <li>
          Once you are happy with the preview, open new tab in your terminal
          (make sure to keep the dev server running), go to the root folder of
          the project and run <code>npm run take-og-snapshot</code>.
        </li>
        <li>
          The command will download dependencies and save the the PNG snapshot
          of the preview into <code>public/og-preview.png</code> file. AppView
          is pre-configured to look for that file and use it as your Open Graph
          preview.
        </li>
        <li>
          Go to <code>app/(main)/layout.tsx</code> file and adjust metadata
          about your app inside the <code>metadata.openGraph</code> and{" "}
          <code>metadata.twitter</code> objects.
        </li>
        <li>That&apos;s it 🎉</li>
      </ol>
    </article>
  );
}
