# AGENTS.md

Guidance for agentic coding assistants working on the Carac website.

This site lives in the `Site/` folder of the carac-ios monorepo (the iOS app is in `../carac/`). Run every command below from `Site/`, and keep website changes inside `Site/` plus `../.github/workflows/site.yml`.

## Quick Facts
- Content: English marketing site for Carac (iPhone and iPad strength training log), with `/policy`, `/terms` and `/release-notes`.
- Download links: `APP_ID` in `src/constants.ts` is `null` until the app is on the App Store, so buttons point to TestFlight; set it to switch to the App Store.
- Deployment: `../.github/workflows/site.yml` publishes `Site/out` to the `gh-pages` branch for `https://carac.jordan-chap.com/`.
- Stack: Next.js App Router + React + TypeScript + MDX.
- Package manager: npm (`package-lock.json` present).
- Build mode: static export (`output: "export"` in `next.config.ts`).
- Styling: CSS Modules (`*.module.css`) plus global styles in `src/global.css`.
- Linting: ESLint flat config in `eslint.config.mjs` (Next Core Web Vitals preset).
- Testing: no dedicated test suite checked in yet.

## Mandatory Rules Discovery
- Checked for Cursor rules in `.cursor/rules/` and `.cursorrules`: none found.
- Checked for Copilot rules in `../.github/copilot-instructions.md`: none found.
- If any of these files are added later, treat them as higher-priority constraints and update this file.

## Commands

### Install
- `npm ci` (from `Site/`)

### Run Dev Server
- `npm run dev`
- Serves local app (default `http://localhost:3000`).

### Build / Start
- `npm run build`
- `npm run start`

### Lint
- Full lint: `npm run lint`
- Lint a single file: `npx eslint src/components/navbar/navbar.tsx`
- Lint a folder: `npx eslint app src --ext .ts,.tsx,.js,.jsx`

### Type Check
- Recommended explicit type check: `npx tsc --noEmit`
- Note: `tsconfig.json` has `"strict": false`; still run type check before merging.

### Tests
- There is currently no `npm test` script and no committed test files.
- Playwright is installed as a dev dependency and used by `scripts/take_og_snapshot.mjs`.
- If you add tests, prefer Playwright and add a `test` script in `package.json`.

### Single-Test Patterns (when tests are added)
- Single spec file: `npx playwright test tests/example.spec.ts`
- Single test by title: `npx playwright test -g "renders hero title"`
- Single test in a file by line: `npx playwright test tests/example.spec.ts:42`
- Run headed for debugging: `npx playwright test tests/example.spec.ts --headed`

### Utility Scripts
- Generate OG image snapshot: `npm run take-og-snapshot`
- Custom snapshot output path: `npm run take-og-snapshot -- public/og-preview.png`
- Import web screenshots from `../AppStore/Screenshots/raw/`: `npm run import-screenshots`
- Generate favicon from app icon (`public/app-icon.png`): `npm run generate-favicon`
- Custom icon path: `APP_ICON_PATH=public/other-icon.png npm run generate-favicon`

## Architecture and Routing Conventions
- Keep routes in `app/` using App Router conventions (`layout.tsx`, `page.tsx`).
- Route groups like `app/(main)` and `app/(dev-tools)` are intentional; preserve grouping.
- Keep static-export compatibility in mind:
  - Avoid server runtime-only APIs for pages meant for export.
  - Prefer static content and deterministic rendering.
- MDX pages are supported via Next MDX config and `.mdx` page extensions.
- Release notes are Markdown files in `app/(main)/release-notes/content/` named `YYYY-MM-DD-slug.md` with a `title` frontmatter. Keep them short and user-facing.

## Import Conventions
- Prefer `@/` alias for imports from `src`.
- Use `@/public/*` alias only for explicit public asset imports when needed.
- Use relative imports for very local sibling modules when clearer.
- Import ordering pattern used across repo:
  1. External packages (`next/*`, `react`, other libs).
  2. Internal alias imports (`@/...`).
  3. Relative imports (`./...`, `../...`).
- Prefer `import type` for type-only imports.

## TypeScript Guidelines
- Type component props with `interface` or `type` aliases.
- Avoid `any`; use unions, literal types, and `Record` where appropriate.
- Keep exported APIs typed explicitly.
- Use `as const` for constant literal maps and arrays (see `MATERIAL_SYMBOLS`, `COLORS`).
- Handle nullable values intentionally (`ClientRuntimeTheme | null` pattern is used).
- Do not rely on implicit widening for configuration objects.

## React and Component Conventions
- Components are function components with named exports.
- Use default exports mainly where framework conventions require them (route `page.tsx`/`layout.tsx`).
- Add `"use client"` only for components that use state/effects/browser APIs.
- Keep props small and descriptive; compose by passing JSX via props where useful.
- Reuse existing composite component APIs (for example `CardGrid.StackedCard`).
- Preserve accessibility attributes (`alt`, semantic headings, link intent).

## Naming Conventions
- File and folder names are snake_case in `src/components` and related modules.
- Exported React component names are PascalCase.
- Variables/functions are camelCase.
- Constants are UPPER_SNAKE_CASE.
- CSS class names in modules are camelCase.
- Keep naming aligned with existing domain language (`bezel`, `theme`, `release notes`, etc.).

## Formatting and Style
- Match existing file-local formatting exactly.
- Current codebase contains both 2-space and tab-indented files; do not mass-reformat.
- Use double quotes and semicolons in TS/TSX to match dominant style.
- Keep line length readable; split long JSX props across lines.
- Keep comments only when they explain non-obvious reasoning.
- Avoid introducing formatting-only diffs.

## CSS and Theming
- Prefer CSS Modules for component-scoped styles.
- Use `src/global.css` for shared global primitives only.
- Keep theme behavior compatible with existing runtime theme context/provider.
- Prefer design tokens and CSS variables over hard-coded repeated values.
- The palette lives in `COLORS` in `src/constants.ts`: the app's green AccentColor (`#34C759` light, `#30D158` dark) on a pale green background in light mode and black in dark mode.
- Screenshots in `public/screenshots/` come in `-light.jpg` and `-dark.jpg` pairs; keep both when replacing one.

## Error Handling
- Fail fast for invalid required inputs in scripts (`console.error` + non-zero exit).
- In async browser utilities, reject promises with actionable `Error` messages.
- Avoid swallowing errors; either propagate or log with context.
- Keep runtime behavior deterministic for static-export pages.

## Data and Runtime Constraints
- Prefer build-time or static data access for route content.
- Avoid introducing APIs that require Node.js runtime for exported routes.
- If a feature truly needs runtime behavior, isolate it behind a client component.
- Keep browser-only logic in hooks/providers/components marked with `"use client"`.

## Git and Change Hygiene
- Do not revert or reformat unrelated files.
- Keep pull requests focused on one concern.
- Preserve public component contracts unless intentionally changing API behavior.
- Document any non-obvious behavior changes in PR notes or commit message.

## Editing Checklist for Agents
- Read nearby code before changing patterns.
- Keep diffs minimal and focused on requested behavior.
- Do not rename public APIs or component contracts without need.
- Do not introduce new dependencies unless justified.
- Run lint and type-check after non-trivial changes.
- If tests exist for changed area, run the smallest relevant subset first.

## Pre-PR Validation Checklist
- `npm run lint`
- `npx tsc --noEmit`
- `npm run build`
- If visual changes were made, run app locally and verify impacted pages.
- If snapshot/favicon scripts were changed, run the related script once.

## Notes for Future Updates
- If test infrastructure is added, update this file with exact `npm test` and single-test commands.
- If Cursor/Copilot rule files appear, add a dedicated section summarizing and linking them.
- Keep this document concise, concrete, and command-oriented.

<!-- BEGIN:nextjs-agent-rules -->

# This is NOT the Next.js you know

This version has breaking changes — APIs, conventions, and file structure may all differ from your training data. Read the relevant guide in `node_modules/next/dist/docs/` (resolved from this file's directory; in monorepos the `next` package may not be visible from the repo root) before writing any code. Heed deprecation notices.

This block is written and re-added by `next dev` — verify at `node_modules/next/dist/server/lib/generate-agent-files.js`. Removing it from a diff only re-creates the uncommitted change; committing it with your work keeps the tree clean.

<!-- END:nextjs-agent-rules -->
