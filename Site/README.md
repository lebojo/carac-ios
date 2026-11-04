# Carac website

Marketing website for [Carac](https://carac.jordan-chap.com/), the strength training log for iPhone and iPad, built with the licensed [AppView template](https://appview.dev). See [LICENSE](LICENSE) for redistribution terms.

It lives in the `Site/` folder of the [carac-ios](https://github.com/lebojo/carac-ios) monorepo. Run every command below from `Site/`.

## Local development

```sh
cd Site
npm ci
npm run dev
```

The site is written in English and uses the English iPhone and iPad screenshots in `public/screenshots/`, in light and dark variants (`*-light.jpg`, `*-dark.jpg`) for the adaptive theme. They are resized for the web from the raw simulator captures in `../AppStore/Screenshots/raw/{iphone,ipad}/en/{light,dark}/` with `npm run import-screenshots` (the list of captures used lives in `scripts/import_screenshots.mjs`). After changing screenshots, refresh the Open Graph image: run `npm run dev`, then `npm run take-og-snapshot` in another terminal. The rounded app icon in `public/app-icon.png` comes from the iOS app icon in `../carac/carac/Assets.xcassets/AppIcon.appiconset/`; regenerate the favicon from it with `npm run generate-favicon`.

## Download link

Carac is not on the App Store yet, so every download button points to the public TestFlight beta. Once the app is live, set `APP_ID` in `src/constants.ts` to its App Store Apple ID: the buttons, their labels and the Safari App Store banner switch to the App Store.

## Validation

```sh
npm run lint
npx tsc --noEmit
npm run build
```

## GitHub Pages

Pushes to `main` that touch `Site/**` run `.github/workflows/site.yml` at the repository root. It exports the site to `Site/out/`, publishes it to the `gh-pages` branch (creating the branch on the first run), and requests a Pages build. The site is built for `https://carac.jordan-chap.com/` at the domain root, with `public/CNAME` retaining the Pages domain setting on each deployment.

The DNS `CNAME` record for `carac` must point to `lebojo.github.io`, and the repository's Pages settings must serve the `gh-pages` branch with the same custom domain. AppView's [GitHub Pages guide](https://appview.dev/docs/guides/deploying_to_github_pages) requires serving the website from the root of a domain.

The carac-ios repository is public while AppView is a paid template: keep [LICENSE](LICENSE) next to this code and keep the active link to [https://appview.dev](https://appview.dev) in this README.
