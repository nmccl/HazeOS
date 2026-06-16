# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Build & Run

This is a pure Xcode project — no SPM scripts, no Makefile. Build and run via Xcode or `xcodebuild`:

```bash
# Build for simulator
xcodebuild -project Haze.xcodeproj -scheme Haze -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run on connected device (requires signing)
xcodebuild -project Haze.xcodeproj -scheme Haze -destination 'platform=iOS,name=<device-name>' run
```

There are no tests and no linter configured.

## Architecture

**No ViewModels.** All state lives directly in views via `@State`. The single shared object is `LocationFetcher`, created as `@StateObject` in `HazeApp` and injected as `@EnvironmentObject` throughout.

**Navigation** is a `TabView` with `.page` style — three horizontal swipe pages. Only `DashboardView` is real; `AdvancedView` and `SettingsView` are stubs.

**Weather data flow:**
1. `LocationFetcher` (CLLocationManager) publishes `location: CLLocation?`
2. Views observe it via `.task(id: locationFetcher.location)`
3. `getWeather(for:)` in `Services/Weather.swift` calls the global `WeatherService()` instance and returns `(temp: Int, condition: AppWeatherCondition)`
4. `AppWeatherCondition` drives all UI appearance

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
2. **Duplicate WeatherKit calls** — `DashboardView` and `CurrentWeather` each independently call `getWeather(for:)`. `WeatherManager.swift` exists as a stub meant to consolidate this.
3. **Live weather bypassed** — `useManualCondition = true` is hardcoded in `DashboardView`. `liveCondition` is fetched but never shown. Flip to `false` once WeatherManager is wired.
4. **`WeeklyView` is hardcoded** — all 6 day columns have fixed SF Symbol names unrelated to real forecast data.
5. **No Apple Weather attribution** — required by WeatherKit ToS; omitting it risks App Store rejection.
6. **`AppColors.swift` imports UIKit** — breaks macOS compilation despite the "Multiplatform" project name.

## Design Rules

- **Backgrounds are flat** (`backgroundColor`) — `backgroundGradient` exists in the code but the current design uses single flat paper tones. `WeatherType` and `WeatherIllustration` are the visual centrepiece, not the background.
- **Text colours** come only from `condition.primaryText` / `condition.secondaryText`. Only `.thunderstorm` is dark-mode (`isDark == true`); all other conditions use near-black text on a light paper background.
- **Typography**: system font throughout, explicit sizes, no bold except `weight: .medium` for active day labels. Temperature is 72pt light.
- **No decorative borders, shadows, or corner radii** on weather UI elements.
- **Uppercase city name**, wide kerning (6pt).
- Temperature is always Fahrenheit (hardcoded — no °C support yet).
