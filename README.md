# FPO Digital Platform Auth UI

This Flutter app now contains a clean authentication foundation for an FPO digital platform.

## What is included

The app starts on the login screen, then navigates to a 4-step FPO registration flow and a submission success screen. The dashboard is a placeholder so the login flow has a clear post-auth destination.

## Folder structure

- `lib/core/theme/` contains the design system colors and `ThemeData`
- `lib/core/constants/` contains routes, UI strings, and shared sizing constants
- `lib/core/navigation/` contains the route generator
- `lib/core/di/` contains the app service wiring
- `lib/features/auth/screens/` contains login, registration, dashboard, and success screens
- `lib/features/auth/widgets/` contains reusable auth UI widgets
- `lib/features/auth/services/` contains API-ready service interfaces and mock implementations

## Theme updates

To adjust the visual system, edit `lib/core/theme/app_colors.dart` and `lib/core/theme/app_theme.dart`. The UI uses the theme for colors, spacing, buttons, cards, inputs, and snackbars.

## Backend integration later

Replace the mock implementations in `lib/features/auth/services/` with real API clients while keeping the same interfaces. The login screen already stores a token through the service layer, and the registration flow already submits a structured request object, so the UI should not need major changes.
# fpo_app

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
