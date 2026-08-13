# Lume Mobile App

The Flutter mobile client for Lume, a creator and community-focused video platform. It delivers native Android and iOS experiences for authentication, discovery, playback, subscriptions, uploads, community interaction, and creator dashboards.

## Stack

| Area | Technology | Purpose |
| --- | --- | --- |
| Mobile framework | Flutter and Dart | Shared Android and iOS application code |
| State management | flutter_bloc, Cubit, Equatable | Predictable feature state and UI updates |
| Networking | Dio, Pretty Dio Logger | REST API calls and development diagnostics |
| Secure session storage | flutter_secure_storage, shared_preferences | Token and local preference handling |
| Routing | go_router | Application navigation and protected flows |
| Video playback | video_player, Chewie | Video rendering and player controls |
| Media selection | image_picker | Image/video selection for uploads |
| UI support | cached_network_image, shimmer, lottie, flutter_svg | Media caching, loading states, motion, and visuals |

## Features

- Login, registration, session restoration, and secure credential storage
- Video feed, search, playback, likes, comments, and subscriptions
- Channel profiles, creator dashboard, and video uploads
- Community posts and user interactions
- Library, settings, splash, and responsive reusable widgets

## Architecture

```text
lib/
|-- core/           # API client, router, constants, secure storage, theme, utilities
|-- data/           # API models and feature repositories
`-- presentation/
    |-- blocs/      # Cubit state and state objects by product area
    |-- screens/    # Feature screens
    `-- widgets/    # Reusable visual components
```

The presentation layer dispatches user actions to Cubits. Cubits call repositories, repositories use the shared API client, and results are emitted as UI states. Access and refresh tokens are persisted through secure storage.

## Run locally

### Prerequisites

- Flutter SDK 3.x
- Dart SDK included with Flutter
- Android Studio or Xcode, depending on your target platform
- A running instance of the [Lume backend](https://github.com/technopradyumn/lume_backend)

### Installation

```bash
git clone https://github.com/technopradyumn/lume_app.git
cd lume_app
flutter pub get
flutter run
```

Choose an Android emulator, iOS simulator, or connected device when prompted.

## API configuration

The local API base URL is defined in `lib/core/constants/app_constants.dart`.

- Android emulators use the host-machine alias `10.0.2.2`.
- iOS simulators and local desktop runs use the loopback address.
- For a physical device or production deployment, replace the local URL with your reachable HTTPS backend URL.

## Useful commands

| Command | Description |
| --- | --- |
| `flutter pub get` | Install Dart and Flutter dependencies |
| `flutter run` | Launch the application on a device or emulator |
| `flutter analyze` | Run static analysis |
| `flutter test` | Run the test suite |
| `flutter build apk` | Build an Android APK |
| `flutter build ios` | Build the iOS application on macOS |

## Related repositories

- [Lume frontend](https://github.com/technopradyumn/lume_frontend)
- [Lume backend](https://github.com/technopradyumn/lume_backend)

## License

ISC
