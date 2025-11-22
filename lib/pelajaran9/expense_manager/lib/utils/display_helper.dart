class DisplayHelper {
  static void clearScreen() {
    print('\\n' * 50);  // Cara sederhana untuk clear lintas platform
  }

  static void printHeader(String title) {
    print('\\n${"═" * 60}');
    print(title.toUpperCase().padRight(60));
    print('${"═" * 60}\\n');
  }

  static void printSuccess(String message) {
    print('✅ $message');
  }

  static void printError(String message) {
    print('❌ $message');
  }

  static void printWarning(String message) {
    print('⚠️  $message');
  }

  static void printInfo(String message) {
    print('ℹ️  $message');
  }

  static void printDivider() {
    print('─' * 60);
  }
}
