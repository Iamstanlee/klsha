class AppConstant {
  const AppConstant._();

  static String get appName => 'Tech Task';

  static String get primaryTypeface => 'Punta';

  static double get appTextScaleFactor => 0.85;
}

enum AppStorageKey {
  ingredients('ingredients');

  final String value;

  const AppStorageKey(this.value);
}
