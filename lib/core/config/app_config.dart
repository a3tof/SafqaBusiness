/// ─────────────────────────────────────────────────────────────────────────
/// SETUP INSTRUCTIONS
/// ─────────────────────────────────────────────────────────────────────────
/// 1. Copy this file:
///      cp lib/core/config/app_config.dart.example lib/core/config/app_config.dart
///
/// 2. Fill in your real credentials below.
///
/// 3. app_config.dart is listed in .gitignore — it will NEVER be committed.
/// ─────────────────────────────────────────────────────────────────────────
abstract class AppConfig {
  // ── Backend API ────────────────────────────────────────────────────────────

  /// Root URL of the SAFQA REST API. Must end with a slash.
  static const String baseUrl = 'https://e-safqa.runasp.net/api/';

  /// Static API key sent as the `x-api-key` header on every request.
  static const String apiKey = 'abc123xyhgfhjgkiho3544351z';

  // ── Google Sign-In ─────────────────────────────────────────────────────────

  /// OAuth 2.0 Web Client ID from the Google Cloud Console.
  /// Used as `serverClientId` in `GoogleSignIn.instance.initialize()`.
  /// Get it from: https://console.cloud.google.com → APIs & Services → Credentials
  static const String googleWebClientId =
      '384971087142-tiq0tughjavrprnc34v4r9i18nhedl25.apps.googleusercontent.com';

  // ── Facebook Login ─────────────────────────────────────────────────────────

  /// Facebook App ID from https://developers.facebook.com → Your App → Settings → Basic
  static const String facebookAppId = 'REPLACE_WITH_FACEBOOK_APP_ID';

  /// Facebook Client Token from: App → Settings → Advanced → Security → Client Token
  /// (This is NOT the App Secret — it is safe to ship in the client binary.)
  static const String facebookClientToken =
      'REPLACE_WITH_FACEBOOK_CLIENT_TOKEN';

  /// Facebook custom-tab redirect scheme — must be  fb{appId}  (auto-derived).
  static const String facebookProtocolScheme = 'fb$facebookAppId';
}
