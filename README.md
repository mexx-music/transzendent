# Transzendent

Mystic hypnosis, relaxation and positive suggestion app built with Flutter.

## Features (aktueller Stand)

- Mystische Hypnose-Sessions mit Kategorien (Entspannung, Schlaf, Motivation, ...)
- Suggestions-Skripte zur positiven Gedankensteuerung
- Audio-Player mit Hintergrundklängen (just_audio)
- Sleep-Timer
- Bibliothek zur Verwaltung von Sessions
- Dark Theme mit Glass-Card-UI
- Plattformübergreifend: Web, Android, iOS, macOS, Windows, Linux

## Voraussetzungen

- Flutter SDK >= 3.9.2
- Dart SDK >= 3.9.2

## Starten (Entwicklung)

```bash
# Web (Chrome)
flutter run -d chrome

# Android
flutter run -d android

# iOS
flutter run -d ios
```

## Build

```bash
# Web (Release)
flutter build web --release

# Web für GitHub Pages (mit base-href)
flutter build web --release --base-href /transzendent/

# Android APK
flutter build apk --release
```

## GitHub Pages deployen

```bash
rm -rf docs
flutter build web --release --base-href /transzendent/
cp -R build/web docs
git add docs
git commit -m "Deploy to GitHub Pages"
git push
```

> GitHub Pages Einstellung: `Settings > Pages > Deploy from branch: main, folder: /docs`

## Projektstruktur

```
lib/
  app/           # Root-App, Theme, Router
  core/          # Models, Widgets, Konstanten
  features/
    home/        # Home Screen, Mini Player Bar
    sessions/    # Session List, Detail, Script Preview
    library/     # Bibliothek
    player/      # Audio Player Service
    settings/    # Einstellungen (geplant)
assets/
  audio/         # Audio-Dateien
  images/        # Bilder
web/             # Flutter Web Konfiguration
```

## Lizenz

Private – alle Rechte vorbehalten.
