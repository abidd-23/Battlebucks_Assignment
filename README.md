# Battlebucks_Assignment

### Project Setup
1. Clone and open:
   ```bash
   git clone <your-repo-url>
   cd Battlebucks
   open Battlebucks.xcodeproj
   ```
2. In Xcode, choose an iOS Simulator (e.g., iPhone 16) and press ⌘R to run.

### iOS & Xcode Version
- iOS SDK: 18.2
- Xcode: 16.x
- Swift: 5.x

### Architecture (MVVM) – Brief
- Model: Plain value types (e.g., `Post`) representing API data.
- ViewModel: `PostsViewModel` exposes observable state (`@Published` posts, search text, loading, error, favorites). It orchestrates fetching via a service, transforms data (filtering), and provides actions (toggle favorite).
- View: SwiftUI views render state and forward user intents to the ViewModel. No networking or business logic in views.
- Services: `NetworkService` handles HTTP (async/await), decoding, and error mapping.

### Assumptions
- JSONPlaceholder endpoint is stable and public; no authentication required.
- Favorites are session-only (in-memory) since persistence specs weren’t mandated.
- Basic accessibility is acceptable; advanced a11y labeling is future work.
- Offline support and caching are out of scope for the initial version.

### Improvements With More Time
- Persist favorites (UserDefaults or Core Data).
- Per-tab navigation history (separate `NavigationPath` per tab).
- Offline caching + retry/backoff strategy; background refresh.
- Unit tests (ViewModel, networking) and UI tests (flows, errors).
- Error surfaces with categorized messages and recovery suggestions.
- Accessibility pass (VoiceOver labels, Dynamic Type, contrast tuning).
- Theming system with light/dark and user-selectable accent colors.
- Performance tuning (image caching if media is added, list virtualization tweaks).
- Analytics hooks for feature usage and error telemetry.
- Localization (strings catalog) and RTL testing.
