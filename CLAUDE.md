# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a pure Xcode project — no SPM scripts, no Makefile. Build and run via Xcode or `xcodebuild`:

```bash
# Build for simulator (use whatever simulator is available — iPhone 16 is not present on this machine, iPhone 17 is)
DEVELOPER_DIR=/Applications/Xcode.app/Contents/Developer xcodebuild -project Haze.xcodeproj -scheme Haze -destination 'platform=iOS Simulator,name=iPhone 17' build CODE_SIGNING_ALLOWED=NO

# Run on connected device (requires signing)
xcodebuild -project Haze.xcodeproj -scheme Haze -destination 'platform=iOS,name=<device-name>' run
```

There are no tests and no linter configured.

## Architecture

**No ViewModels.** All state lives directly in views via `@State`. The single shared object is `LocationFetcher`, created as `@StateObject` in `HazeApp` and injected as `@EnvironmentObject` throughout.

**Navigation** is a `TabView` with `.page` style — three horizontal swipe pages. Only `DashboardView` is real; `AdvancedView` and `SettingsView` are stubs.

**Weather data flow:**
1. `LocationFetcher` (CLLocationManager) publishes `location: CLLocation?`
2. `DashboardView` observes it via `.task(id: activeLocation)` — `activeLocation` is `manualLocation ?? locationFetcher.location`
3. `getWeather(for:)` in `Services/Weather.swift` calls the global `weatherService` (`WeatherService`) instance and returns `WeatherData` — a struct with `temp: Int`, `condition: AppWeatherCondition`, `windSpeed: Int`, `windDirection: WindDirection`, and `forecast: [DayForecast]` (next 5 days)
4. `AppWeatherCondition` drives all UI appearance
5. **Auto-refresh**: `DashboardView`'s `.task(id: activeLocation)` loops with `Task.sleep(for: .seconds(900))` after the initial load, silently refreshing every 15 minutes. The task is cancelled and restarted whenever `activeLocation` changes.

## Central Type: `AppWeatherCondition`

`Services/WeatherCondition.swift` — the enum that everything renders from. 7 cases: `.clear` `.cloudy` `.rainy` `.snowy` `.thunderstorm` `.foggy` `.hazy`.

Appearance is split across two files intentionally:
- `WeatherCondition.swift` — gradient properties (`iconGradient`, `backgroundGradient`) and WeatherKit mapping (`from(_:)`)
- `WeatherAppearance.swift` — flat/paper UI properties (`backgroundColor`, `accentColor`, `primaryText`, `secondaryText`, `isDark`)

When adding a new condition case, both files need updating.

## Illustrations

`Components/WeatherIllustration.swift` uses SwiftUI `Canvas` — one `draw*` function per condition. The shared design motif is: fill a shape with `accentColor`, then cut horizontal stripes through it by drawing `backgroundColor`-coloured lines on top (since the canvas sits on a matching background, these read as transparent gaps). Do not introduce image assets or SF Symbols into illustrations — keep them as Canvas paths.

## Known Issues

1. **`City.swift` creates its own `@StateObject private var locationFetcher`** — a second CLLocationManager running in parallel with the root one. Should use `@EnvironmentObject`.
2. **`CurrentWeather.swift` is dead code** — it independently calls `getWeather(for:)` but is not referenced anywhere in the active view hierarchy. `WeatherManager.swift` also exists as a stub meant to consolidate weather fetching but is unused.
3. **`AppColors.swift` imports UIKit** — breaks macOS compilation despite the "Multiplatform" project name.

## Resolved (for reference)

- ~~Live weather bypassed~~ — `useManualCondition` is now `false`; live WeatherKit data is displayed.
- ~~`WeeklyView` is hardcoded~~ — `WeeklyView` now receives real `[DayForecast]` data from `getWeather` and renders actual 5-day forecasts.
- ~~No Apple Weather attribution~~ — attribution is in the `LocationSelectorView` footer: the official Apple Weather mark (`AsyncImage` from `WeatherAttribution`) linked to `legalPageURL`, with a text fallback. Submitted to App Store 2026-06-24 for Guideline 5.2.5 compliance.

## Design Rules

- **Backgrounds are flat** (`backgroundColor`) — `backgroundGradient` exists in the code but the current design uses single flat paper tones. `WeatherType` and `WeatherIllustration` are the visual centrepiece, not the background.
- **Text colours** come only from `condition.primaryText` / `condition.secondaryText`. Only `.thunderstorm` is dark-mode (`isDark == true`); all other conditions use near-black text on a light paper background.
- **Typography**: system font throughout, explicit sizes, no bold except `weight: .medium` for active day labels. Temperature is 72pt light.
- **No decorative borders, shadows, or corner radii** on weather UI elements.
- **Uppercase city name**, wide kerning (6pt).
- Temperature is always Fahrenheit (hardcoded — no °C support yet).
