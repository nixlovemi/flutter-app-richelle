/// Supported languages for the app
enum AppLanguage {
  portuguese('pt', 'Português'),
  english('en', 'English');

  const AppLanguage(this.code, this.displayName);
  final String code;
  final String displayName;
}