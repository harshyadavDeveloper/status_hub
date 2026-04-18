# Status Hub 🔥

> **Make it. Vibe it. Share it.**
> A multi-language status maker app for WhatsApp, Instagram & more — built with Flutter.

---

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Tech Stack](#tech-stack)
- [Project Structure](#project-structure)
- [Getting Started](#getting-started)
- [Firebase Setup](#firebase-setup)
- [GIPHY Integration](#giphy-integration)
- [Adding Trending Templates](#adding-trending-templates)
- [Festival Calendar](#festival-calendar)
- [Building for Release](#building-for-release)
- [Play Store Checklist](#play-store-checklist)
- [Roadmap](#roadmap)
- [Contributing](#contributing)

---

## Overview

Status Hub is a Flutter app that lets users browse, customize, and share beautiful status templates for WhatsApp, Instagram Stories, and other social platforms. It supports multiple Indian languages (English, Hindi, Marathi, and more), GIPHY stickers, gradient backgrounds, and a seasonal trending section powered by Firebase Remote Config — so you can push fresh festival and IPL templates without releasing a new app version.

---

## Features

### Core
- Browse a rich library of pre-built status templates
- Filter by **language** (English, Hindi, Marathi) and **category** (Motivational, Attitude, Sad, IPL, etc.)
- Save favourites for quick access
- Create from scratch with a full canvas editor

### Editor
- Live gradient background picker (6 colour schemes)
- Google Fonts integration — 6 curated font families (Poppins, Pacifico, Dancing Script, Lobster, Abril Fatface, Righteous)
- Font size slider (12px–48px)
- Text colour picker
- Bold / Italic / Text alignment toggles
- GIPHY sticker picker — search or browse trending stickers
- Drag stickers freely on the canvas
- Long-press a sticker to remove it

### Sharing
- Save to gallery (Android & iOS)
- Share directly via any installed app (WhatsApp, Instagram, etc.)
- High-resolution capture at 3× pixel ratio

### Trending & Seasonal
- **Firebase Remote Config** powers the trending section — update templates weekly without an app release
- **Festival Calendar Banner** — auto-detects the next upcoming Indian festival and surfaces relevant templates
- 21 trending sections covering IPL, Diwali, Eid, Raksha Bandhan, Navratri, Dussehra, Independence Day, Bollywood, Gym, Love, Student Life, and more

---

## Tech Stack

| Layer | Technology |
|---|---|
| Framework | Flutter 3.x (Dart) |
| State Management | Provider |
| Backend / Config | Firebase Remote Config |
| Stickers | GIPHY API (beta key) |
| Fonts | Google Fonts |
| Image Capture | RepaintBoundary (native Flutter) |
| Gallery Save | saver_gallery |
| Sharing | share_plus |
| Networking | http |
| Image Caching | cached_network_image |
| Animations | flutter_animate |
| Splash Screen | flutter_native_splash |
| App Icon | flutter_launcher_icons |

---

## Project Structure

```
lib/
├── core/
│   └── constants/
│       ├── app_colors.dart        # Colour palette, gradients
│       ├── app_fonts.dart         # Font families, text styles
│       └── app_string.dart        # String constants, GIPHY API key
│
├── data/
│   ├── dummy_templates.dart       # Hardcoded starter templates
│   ├── festival_calendar.dart     # 2026 Indian festival dates & metadata
│   ├── giphy_service.dart         # GIPHY API — trending & search
│   ├── remote_config_service.dart # Firebase Remote Config fetch & parse
│   └── trending_data.json         # Reference JSON for Remote Config value
│
├── models/
│   └── template_model.dart        # Template data model
│
├── providers/
│   ├── editor_provider.dart       # Canvas state (text, font, gradient, stickers)
│   └── template_provider.dart     # Template list, filters, trending sections
│
├── screens/
│   ├── home/
│   │   └── home_screen.dart       # Template grid, filters, trending & festival banner
│   ├── editor/
│   │   ├── editor_screen.dart     # Edit existing template
│   │   └── create_screen.dart     # Create from scratch
│   └── favorites/
│       └── favorites_screen.dart  # Saved templates
│
├── widgets/
│   ├── template_card.dart         # Grid card — preview, favourite, language badge
│   ├── giphy_picker_sheet.dart    # Bottom sheet — GIPHY sticker search & grid
│   └── festival_banner.dart       # Hero banner + upcoming strip for festivals
│
└── main.dart                      # App entry, Firebase init, bottom nav shell
```

---

## Getting Started

### Prerequisites

- Flutter SDK `>=3.0.0`
- Dart SDK `>=3.0.0`
- Android Studio or VS Code with Flutter extension
- A Firebase project (see [Firebase Setup](#firebase-setup))
- A GIPHY developer account (see [GIPHY Integration](#giphy-integration))

### Clone & Install

```bash
git clone https://github.com/yourusername/status_hub.git
cd status_hub
flutter pub get
```

### Add your API keys

Open `lib/core/constants/app_string.dart` and replace the placeholder:

```dart
static const String giphyApiKey = 'YOUR_GIPHY_API_KEY_HERE';
```

### Run

```bash
flutter run
```

---

## Firebase Setup

### 1. Create a Firebase project

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Create a new project named `status-hub`
3. Add an Android app with package name `com.example.status_hub`
4. Download `google-services.json` and place it at `android/app/google-services.json`

### 2. Enable Remote Config

1. In the Firebase console, navigate to **Remote Config**
2. Click **Create Configuration**
3. Add a parameter with key `trending_templates`
4. Paste the contents of `lib/data/trending_data.json` as the default value
5. Click **Save** → **Publish Changes**

### 3. Gradle setup

`android/settings.gradle.kts` — make sure this plugin is included:
```kotlin
id("com.google.gms.google-services") version "4.4.2" apply false
```

`android/app/build.gradle.kts` — apply the plugin:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

---

## GIPHY Integration

Status Hub uses the GIPHY Stickers API to power the sticker picker in the editor.

### Getting a key

1. Create an account at [developers.giphy.com](https://developers.giphy.com)
2. Click **Create an App** → select **API**
3. Copy the generated API key
4. Paste it into `lib/core/constants/app_string.dart`

### Rate limits

Beta keys are limited to **100 API calls per hour** — more than enough for a status app at early stage. If you need more, apply for a production key via the GIPHY developer dashboard.

### How it works

- `GiphyService.fetchTrending()` — loads trending stickers on sheet open
- `GiphyService.searchStickers(query)` — searches on user input
- Stickers are rendered on the canvas as draggable widgets
- Long-press a sticker on the canvas to remove it
- The canvas captures stickers at 3× resolution when saving or sharing

---

## Adding Trending Templates

Templates in the trending section are entirely driven by Firebase Remote Config — no app update needed to add new ones.

### JSON structure

```json
{
  "trending": [
    {
      "id": "section_id",
      "title": "Section Title 🔥",
      "templates": [
        {
          "id": "unique_template_id",
          "text": "Your status text here ✨",
          "gradientColors": ["#6C63FF", "#9C95FF"],
          "fontFamily": "Poppins",
          "category": "Motivational",
          "language": "English"
        }
      ]
    }
  ]
}
```

### Available gradient presets

| Name | Colors |
|---|---|
| Purple | `#6C63FF` → `#9C95FF` |
| Sunset | `#FF6584` → `#FFB347` |
| Ocean | `#43D98C` → `#0ED2F7` |
| Night | `#1A1A2E` → `#16213E` |
| Rose | `#f093fb` → `#f5576c` |
| Gold | `#f7971e` → `#ffd200` |

### Available font families

`Poppins`, `Lobster`, `Pacifico`, `Dancing Script`, `Abril Fatface`, `Righteous`

### Updating templates

1. Go to **Firebase Console → Remote Config**
2. Edit the `trending_templates` parameter
3. Update or add sections/templates in the JSON
4. Click **Save** → **Publish Changes**

Changes go live within 1 hour (the configured `minimumFetchInterval`). During development this is reduced to 0 — set it back to `Duration(hours: 1)` before release.

---

## Festival Calendar

The festival banner at the top of the home screen is powered by a local calendar in `lib/data/festival_calendar.dart`. It auto-detects festivals happening within the next 30 days and surfaces them as:

- A **hero banner** for the nearest upcoming event with a countdown
- A **horizontal strip** of all other upcoming events in the next 30 days

Tapping a festival banner opens the matching trending section from Firebase Remote Config directly in the editor. If no templates exist yet for that festival, a "coming soon" sheet is shown instead.

### 2026 festival coverage

| Festival | Date | Trending Section ID |
|---|---|---|
| IPL 2026 | April 1 | `ipl_2026` |
| Eid Mubarak | March 30 | `eid_2026` |
| Mother's Day | May 10 | `mothers_day_2026` |
| Buddha Purnima | May 23 | `buddha_purnima_2026` |
| Friendship Day | August 2 | `friendship_day_2026` |
| Independence Day | August 15 | `independence_day_2026` |
| Raksha Bandhan | August 28 | `raksha_bandhan_2026` |
| Ganesh Chaturthi | September 11 | `ganesh_chaturthi_2026` |
| Navratri | October 9 | `navratri_2026` |
| Dussehra | October 19 | `dussehra_2026` |
| Diwali | November 8 | `diwali_2026` |
| Christmas | December 25 | `christmas_2026` |
| New Year 2027 | January 1 | `new_year_2027` |

To add a new festival, append an entry to `festivalCalendar2026` in `festival_calendar.dart` and add matching templates to Remote Config with the same `trendingSectionId`.

---

## Building for Release

### 1. Create a keystore (one time only)

```bash
keytool -genkey -v \
  -keystore ~/status_hub_keystore.jks \
  -keyalg RSA -keysize 2048 \
  -validity 10000 \
  -alias status_hub
```

**Keep this file and your passwords safe. You will need them for every future update. Losing the keystore means you cannot update the app on the Play Store.**

### 2. Create `android/key.properties`

```properties
storePassword=YOUR_STORE_PASSWORD
keyPassword=YOUR_KEY_PASSWORD
keyAlias=status_hub
storeFile=/path/to/status_hub_keystore.jks
```

Add `key.properties` and `*.jks` to `.gitignore`.

### 3. Build the release AAB

```bash
flutter clean
flutter pub get
flutter build appbundle --release
```

Output: `build/app/outputs/bundle/release/app-release.aab`

### 4. Generate app icon and splash screen

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

---

## Play Store Checklist

| Item | Notes |
|---|---|
| App icon (512×512 PNG) | Generated from `assets/icon/app_icon.png` |
| Feature graphic (1024×500 PNG) | Create on Canva — use purple gradient theme |
| Screenshots (min 2, max 8) | Home, Editor, Trending, Favourites |
| Short description (max 80 chars) | Make & share status in Hindi, English & more |
| Full description (max 4000 chars) | See below |
| Privacy policy URL | Required — use privacypolicytemplate.net |
| Content rating questionnaire | Fill in Play Console — select 13+ |
| App category | Lifestyle or Photography |
| Target countries | India (primary), Pakistan, Bangladesh, Nepal |

### Suggested Play Store description

```
Status Hub is the ultimate status maker for WhatsApp, Instagram, and Facebook.
Browse hundreds of beautiful templates across multiple Indian languages — Hindi,
English, Marathi, and more — or create your own from scratch.

✨ FEATURES
• 200+ ready-made templates across 10+ categories
• Multi-language support — Hindi, English, Marathi
• Full canvas editor — fonts, gradients, text styles
• GIPHY sticker picker — add animated stickers to your status
• Trending section — updated weekly for IPL, Diwali, Eid & more
• Festival calendar — auto-suggests templates for upcoming festivals
• Save to gallery or share directly to WhatsApp, Instagram & more

🎨 EDITOR
• 6 gradient colour schemes
• 6 premium font families
• Bold, italic, text alignment
• Drag-and-drop stickers
• High-resolution export

🔥 TRENDING
New templates every week around festivals, IPL, Bollywood releases,
and everyday moods — Monday Motivation, Friday Vibes, and more.

Download Status Hub and express yourself in your own language. 🚀
```

---

## Roadmap

- [ ] Gujarati and Tamil language support
- [ ] Custom background image picker (from gallery)
- [ ] Text shadow and outline options
- [ ] Template packs — downloadable themed collections
- [ ] User-submitted templates with moderation
- [ ] Scheduled status reminder notifications
- [ ] Watermark / branding toggle
- [ ] iOS release

---

## Contributing

Pull requests are welcome. For major changes please open an issue first to discuss what you would like to change.

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

---

## License

This project is licensed under the MIT License. See `LICENSE` for details.

---

## Acknowledgements

- [Flutter](https://flutter.dev) — UI framework
- [Firebase](https://firebase.google.com) — Remote Config & backend
- [GIPHY](https://developers.giphy.com) — Sticker API
- [Google Fonts](https://fonts.google.com) — Typography
- [Provider](https://pub.dev/packages/provider) — State management

---

*Built with ❤️ for the Indian social media market.*
