# Carac on the App Store

Everything needed to fill the App Store Connect product page of Carac, in English (`en-US`) and French (`fr-FR`).

```
AppStore/
├── Metadata/<locale>/        name, subtitle, promotional text, description, keywords, release notes, URLs
├── Screenshots/
│   ├── raw/<device>/<lang>/<light|dark>/   plain simulator captures, no bezel, no caption
│   ├── config/<lang>.json                  captions and layout of the screenshots
│   ├── export/<lang>/<device>/NN.png        final screenshots uploaded to App Store Connect
│   └── Carac-<LANG>.pco                     screenshot project, to fine tune them in the mockup app
├── Creatives/<lang>/          iOS 27 product page header and search results images
└── Scripts/                   generators for the creatives
```

## Metadata

One file per App Store Connect field, in the fastlane `deliver` layout, so the folder can be uploaded with `fastlane deliver` or copied by hand. Lengths are within Apple's limits (name and subtitle 30, promotional text 170, keywords 100).

The support, marketing and privacy URLs point to the website in `Site/` at `https://carac.jordan-chap.com`.

## Screenshots

The raw captures come from the iPhone 18 Pro Max (1320 × 2868, the 6.9" class) and the 13" iPad Pro (2064 × 2752) simulators, on iOS 27, with the status bar set to 9:41, full battery and full signal. They were taken from a Debug build seeded with eight weeks of realistic training history.

| # | Raw file | English caption | French caption |
| --- | --- | --- | --- |
| 1 | `01-home` | Your training week, planned | Votre semaine, planifiée |
| 2 | `02-exercise` | Log every set in a tap | Chaque série notée d’un geste |
| 3 | `04-progress` | Watch yourself get stronger | Voyez vos progrès |
| 4 | `03-session` | Your whole session at a glance | Toute la séance d’un coup d’œil |
| 5 | `05-calendar` | Every session, day by day | Chaque séance, jour après jour |
| 6 | `06-trainings` | Build trainings your way | Vos entraînements, à votre façon |

The final screenshots in `export/` have the caption and the device frame. Regenerate them after changing a caption or a capture:

```sh
python3 AppStore/Scripts/make_screenshots.py
```

Upload them with the [`asc`](https://github.com/rorkai/App-Store-Connect-CLI) CLI, one set per locale and device:

```sh
asc screenshots upload --version-localization LOCALIZATION_ID --path AppStore/Screenshots/export/en/iphone --device-type IPHONE_69 --replace --confirm --concurrency 1
asc screenshots upload --version-localization LOCALIZATION_ID --path AppStore/Screenshots/export/en/ipad --device-type IPAD_PRO_3GEN_129 --replace --confirm --concurrency 1
```

Keep `--concurrency 1`: parallel uploads can land out of order in the set.

The `.pco` projects hold the same captions for the mockup app. Regenerate them with:

```sh
python3 ~/.claude/skills/appstore-screenshots-pco/generate_pco.py AppStore/Screenshots/config/en.json AppStore/Screenshots/Carac-EN.pco
python3 ~/.claude/skills/appstore-screenshots-pco/generate_pco.py AppStore/Screenshots/config/fr.json AppStore/Screenshots/Carac-FR.pco
```

The dark captures are not used on the App Store; the website uses them for its dark theme.

## Product page header and search results (iOS 27)

Since October 2026, App Store Connect accepts two creative assets that show on iOS 27 and iPadOS 27 and later, stored in the App Store Asset Library and reviewed by Apple before they go live:

| File | Placement | Size | Ratio |
| --- | --- | --- | --- |
| `Creatives/<lang>/header.png` | Product page header, above the icon and screenshots | 3840 × 1646 | 21:9 |
| `Creatives/<lang>/search.png` | Search results card, instead of the screenshot strip | 3840 × 2560 | 3:2 |
| `Creatives/<lang>/universal.png` | Both, with "Use header asset in search results" | 5244 × 2950 | 16:9 |

Upload either `header.png` and `search.png`, or only `universal.png`. The images have no alpha channel, as Apple requires. The header and the search card crop differently, so the headline and the phones stay away from the edges. Check the result in the App Store Connect preview before submitting.

Regenerate them from the light iPhone captures:

```sh
python3 AppStore/Scripts/make_creatives.py
```

The device frame in `Scripts/bezel/` comes from the AppView template used by the website, under the same license.
