# MediRescue — Emergency Medical Assistance App

A production-structured Flutter app matching the provided UI: login/sign up,
a "Stay Safe" home hub, a medical profile form with an emergency-type grid,
a confirm-location screen, and a live ambulance-assignment tracker.

## Getting started

```bash
flutter pub get
flutter run
```

Requires Flutter 3.19+ (Dart 3+). No API keys or backend are required — all
network calls are simulated by the repository classes in `lib/services/`.

## Architecture

```
lib/
  main.dart                    # Entry point
  app.dart                     # MaterialApp + provider wiring
  theme/app_theme.dart         # Colors, radii, spacing, ThemeData
  models/                      # Plain Dart models with fromJson/toJson
    user_model.dart
    medical_profile_model.dart
    emergency_type_model.dart
    ambulance_model.dart       # + HospitalModel
  services/                    # Mock repositories simulating API calls
    auth_repository.dart
    medical_repository.dart
    ambulance_repository.dart
  providers/                   # ChangeNotifier state managers (Provider)
    view_state.dart            # Shared Loading/Success/Empty/Error wrapper
    auth_provider.dart
    medical_profile_provider.dart
    emergency_provider.dart
  routes/app_router.dart       # Named routes + custom fade/slide transitions
  widgets/                     # Reusable, composable UI pieces
    custom_text_field.dart
    primary_button.dart
    home_action_card.dart
    emergency_type_card.dart
    mock_map_background.dart
    state_views.dart           # LoadingView / ErrorView / EmptyView
  screens/
    auth/  home/  medical_profile/  emergency/  hospitals/
```

## State management

Uses **Provider** with `ChangeNotifier`. Each feature has its own provider
(`AuthProvider`, `MedicalProfileProvider`, `EmergencyProvider`) exposing a
`ViewState<T>` (`initial / loading / success / empty / error`) so every
screen renders the same four UI states consistently.

## Navigation

Named routes via `Navigator.onGenerateRoute` (see `AppRouter`), wrapped in a
`PageRouteBuilder` that applies a shared fade + slide transition. Swap this
for `go_router` by mapping the same route table into `GoRoute`s if
deep-linking is needed later.

## Flow

1. **Auth**: `/login` → `/signup` / `/forgot-password`
2. **Home** (`/home`): Emergency, My Medical Profile, Nearby Hospitals
3. **Medical Profile** (`/medical-profile`): demographics form + emergency
   type grid, saved through `MedicalRepository`
4. **Emergency workflow**: `/confirm-location` → `/ambulance-assigned`
   (live ETA, equipment list, call driver/medical team, cancel)
5. **Nearby Hospitals** (`/hospitals`): list with call-to-action per hospital

## Notes on mocked pieces

- `MockMapBackground` draws a lightweight grid instead of embedding
  `google_maps_flutter`, so the app runs without API keys. Swap it for a real
  map widget by keeping the same child/overlay structure.
- BMI is derived from weight alone (using an assumed average height) since
  the source design only collects age and weight — replace
  `MedicalProfileModel.bmi` with a real height-based calculation once a
  height field is added.
- All repositories use `Future.delayed` + validation to simulate real
  network latency and error responses; replace their bodies with real HTTP
  calls (e.g. `dio`/`http`) without touching any screen or provider code.
