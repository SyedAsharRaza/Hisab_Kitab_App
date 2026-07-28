class AppConstants {
  AppConstants._(); // private take kahi koi or create na kar le

  static const String appName = 'HisabKitab';
  static const String tagline = 'Friendship in its place, accounts in theirs';

  // Firestore collection ke names
  static const String usersCollection = 'users';
  static const String ledgerEntriesCollection = 'ledger_entries';

  // SharedPreferences keys ke names and default values
  static const String keyHasSeenOnboarding = 'has_seen_onboarding';
  static const String keyCurrencySymbol = 'currency_symbol';

  // FlutterSecureStorage keys (although mene use nhi kara)
  static const String keyAuthUid = 'auth_uid';

  // default
  static const String defaultCurrency = '\$';

  // design
  static const double designWidth = 375; // base design width for scaling
  static const double designHeight = 812;
}