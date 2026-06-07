# Safqa Seller - Technical Documentation

`Safqa Seller` is the Flutter application designed for the sellers on the Safqa auction platform. It provides a comprehensive suite of tools for seller onboarding, authentication, profile management, auction creation and management, transaction history, real-time notifications, chat, wallet management, and subscription upgrades.

---

## 1. Project Overview
Safqa Seller is built using Flutter and follows a robust MVVM (Model-View-ViewModel) architecture. It is designed to be responsive, localized (Arabic and English), and capable of handling background tasks such as notifications.

## 2. Tech Stack & Key Dependencies
The project leverages the following core technologies and packages:

- **Framework**: Flutter (SDK `^3.10.3`)
- **State Management**: `flutter_bloc` & `bloc` (Cubit-based)
- **Dependency Injection**: `get_it` (Service Locator)
- **Networking**: `dio`
- **Local Storage**: `shared_preferences`
- **Background Tasks**: `workmanager`, `flutter_foreground_task`
- **Notifications**: `flutter_local_notifications`
- **Authentication**: `google_sign_in`, `flutter_facebook_auth`
- **UI & Layout**: `flutter_screenutil` (responsive sizing), `skeletonizer` (loading states), `dots_indicator`
- **Localization**: `flutter_localizations`, `intl`
- **Assets & Icons**: `flutter_svg`, `cupertino_icons`

## 3. Project Structure
The codebase follows a feature-first architecture, allowing scalable and modular development.

```text
lib/
├── core/
│   ├── config/             # App configuration (Base URLs, API Keys)
│   ├── helper_functions/   # Routing and shared utilities
│   ├── network/            # Dio client and interceptors
│   ├── service_locator.dart# GetIt dependency injection setup
│   ├── storage/            # Local storage implementations
│   ├── utils/              # Constants, App Images (generated)
│   └── widgets/            # Reusable UI components
├── features/
│   ├── adaptive_layout/    # Responsive design helpers
│   ├── auction/            # Auction creation, editing, and details
│   ├── auth/               # Login and registration
│   ├── change_password/    # Password update flow
│   ├── chat/               # Real-time messaging
│   ├── complete_profile/   # Seller onboarding flow
│   ├── forgot_password/    # Password recovery
│   ├── history/            # Transaction and auction history
│   ├── home/               # Seller dashboard
│   ├── notifications/      # In-app alerts
│   ├── on_boarding/        # Initial app walk-through
│   ├── profile/            # Seller profile and account editing
│   ├── seller/             # Seller-specific configurations
│   ├── splash/             # Splash screen
│   ├── subscription/       # Subscription plans and upgrades
│   ├── terms_and_conditions/# Legal agreements
│   └── wallet/             # Wallet, cards, deposits, withdrawals
```

### Key Architectural Conventions:
- **Views**: UI components and screens reside under `features/<feature>/view/`.
- **ViewModels**: Business logic and state management (Cubits/States) reside under `features/<feature>/view_model/`.
- **Models**: Data classes, DTOs, and repositories reside under `features/<feature>/model/`.

## 4. Main Features
- **Authentication & Onboarding**: Multi-provider login (Google, Facebook), secure account recovery, and a complete profile setup flow for new sellers.
- **Auction Management**: Create, edit, and monitor active auctions.
- **Dashboard & History**: A comprehensive home dashboard displaying seller metrics, along with detailed transaction and auction history.
- **Communication**: Real-time chat threads with buyers and platform administrators.
- **Financials**: Integrated wallet system supporting deposits, withdrawals, and subscription plan management.
- **Notifications**: Background and foreground notification handling for real-time auction updates.
- **Localization**: Full support for English (`en`) and Arabic (`ar`) out-of-the-box.

## 5. Assets & Theming
- **Fonts**: The application utilizes custom typography including `Cairo`, `Inter`, and `AlegreyaSC` to provide a premium look and feel.
- **Images/Icons**: Managed centrally via generated utility classes (`app_images.dart`).

## 6. Getting Started

### Prerequisites
- Flutter SDK compatible with Dart `^3.10.3`
- Target platform setup (Android Studio / Xcode)

### Installation
1. Clone the repository.
2. Install dependencies:
   ```bash
   flutter pub get
   ```

### Configuration
Review `lib/core/config/app_config.dart` before running the app. It contains:
- API Base URL
- API Keys
- OAuth Client IDs (Google/Facebook)

### Running the App
```bash
flutter run
```

## 7. Development Guidelines

### State Management
- Use `Cubit` for managing feature states instead of event-based `Bloc`.
- Register Repositories as lazy singletons and screen-scoped Cubits as factories using `GetIt`.

### Routing
- Centralized in `lib/core/helper_functions/on_generate_routes.dart`.
- Ensure type-safe argument passing using dedicated argument classes.

### Localization
- Add new strings to the ARB files located under `lib/l10n/`.
- Access strings using `S.of(context)` within widgets.

### Useful Commands
```bash
flutter analyze
flutter test
dart format lib test
```

## 8. License & Proprietary Info
This repository is private and intended for internal Safqa development. It includes various Python utility scripts (`localize.py`, `clean.py`, etc.) and Swagger definitions (`swagger_v1.json`) used for code generation and maintenance.
