import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccessibilityProvider extends ChangeNotifier {
  SharedPreferences? _prefs;

  double _fontSizeMultiplier = 1.0;
  bool _isDyslexicFont = false;
  String _dyslexicFontType = 'Lexend'; // 'Lexend' or 'OpenDyslexic'
  bool _isHighContrast = false;
  double _letterSpacing = 0.0;
  bool _isDarkMode = false;

  AccessibilityProvider() {
    _loadFromPrefs();
  }

  double get fontSizeMultiplier => _fontSizeMultiplier;

  bool get isDyslexicFont => _isDyslexicFont;

  String get dyslexicFontType => _dyslexicFontType;

  bool get isHighContrast => _isHighContrast;

  double get letterSpacing => _letterSpacing;

  bool get isDarkMode => _isDarkMode;

  Future<void> _loadFromPrefs() async {
    _prefs = await SharedPreferences.getInstance();
    _fontSizeMultiplier = _prefs?.getDouble('fontSizeMultiplier') ?? 1.0;
    _isDyslexicFont = _prefs?.getBool('isDyslexicFont') ?? false;
    _dyslexicFontType = _prefs?.getString('dyslexicFontType') ?? 'Lexend';
    _isHighContrast = _prefs?.getBool('isHighContrast') ?? false;
    _letterSpacing = _prefs?.getDouble('letterSpacing') ?? 0.0;
    _isDarkMode = _prefs?.getBool('isDarkMode') ?? false;
    notifyListeners();
  }

  void setLetterSpacing(double value) {
    _letterSpacing = value;
    _prefs?.setDouble('letterSpacing', value);
    notifyListeners();
  }

  void setFontSize(double value) {
    _fontSizeMultiplier = value;
    _prefs?.setDouble('fontSizeMultiplier', value);
    notifyListeners();
  }

  void setIsDyslexicFont(bool value) {
    _isDyslexicFont = value;
    _prefs?.setBool('isDyslexicFont', _isDyslexicFont);
    notifyListeners();
  }

  void setDyslexicFontType(String fontType) {
    if (fontType == 'Lexend' || fontType == 'OpenDyslexic') {
      _dyslexicFontType = fontType;
      _prefs?.setString('dyslexicFontType', _dyslexicFontType);
      notifyListeners();
    }
  }

  void toggleDyslexicFont() {
    _isDyslexicFont = !_isDyslexicFont;
    _prefs?.setBool('isDyslexicFont', _isDyslexicFont);
    notifyListeners();
  }

  void toggleDarkMode() {
    _isDarkMode = !_isDarkMode;
    _prefs?.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void setIsDarkMode(bool value) {
    _isDarkMode = value;
    _prefs?.setBool('isDarkMode', _isDarkMode);
    notifyListeners();
  }

  void toggleHighContrast() {
    _isHighContrast = !_isHighContrast;
    _prefs?.setBool('isHighContrast', _isHighContrast);
    notifyListeners();
  }

  void setIsHighContrast(bool value) {
    _isHighContrast = value;
    _prefs?.setBool('isHighContrast', _isHighContrast);
    notifyListeners();
  }

  /// Generates theme based on current accessibility settings
  /// Only change _isHighContrast or _isDarkMode to control the theme
  /// Only change _fontSizeMultiplier to control all font sizes
  ThemeData get theme {
    if (_isHighContrast) {
      return _isDarkMode ? _buildHighContrastDarkTheme() : _buildHighContrastLightTheme();
    }
    return _isDarkMode ? _buildDarkTheme() : _buildLightTheme();
  }

  /// Getter for TextTheme that respects accessibility settings
  TextTheme get textTheme => theme.textTheme;

  ThemeData _buildLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      useMaterial3: true,
      textTheme: TextTheme(
        displayLarge: _createTextStyle(32),
        displayMedium: _createTextStyle(28),
        displaySmall: _createTextStyle(24),
        headlineMedium: _createTextStyle(22),
        headlineSmall: _createTextStyle(20),
        titleLarge: _createTextStyle(18),
        titleMedium: _createTextStyle(16),
        titleSmall: _createTextStyle(14),
        bodyLarge: _createTextStyle(16),
        bodyMedium: _createTextStyle(14),
        bodySmall: _createTextStyle(12),
        labelLarge: _createTextStyle(14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: _createTextStyle(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: _createTextStyle(20),
      ),
    );
  }

  // Dark theme
  ThemeData _buildDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      useMaterial3: true,
      textTheme: TextTheme(
        displayLarge: _createTextStyle(32),
        displayMedium: _createTextStyle(28),
        displaySmall: _createTextStyle(24),
        headlineMedium: _createTextStyle(22),
        headlineSmall: _createTextStyle(20),
        titleLarge: _createTextStyle(18),
        titleMedium: _createTextStyle(16),
        titleSmall: _createTextStyle(14),
        bodyLarge: _createTextStyle(16),
        bodyMedium: _createTextStyle(14),
        bodySmall: _createTextStyle(12),
        labelLarge: _createTextStyle(14),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          textStyle: _createTextStyle(16),
        ),
      ),
      appBarTheme: AppBarTheme(
        titleTextStyle: _createTextStyle(20),
      ),
    );
  }

  ThemeData _buildHighContrastDarkTheme() {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black,
      primaryColor: Colors.yellow,
      colorScheme: const ColorScheme.dark(
        primary: Colors.yellow,
        onPrimary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.yellow,
        outline: Colors.yellow,
      ),
      textTheme: TextTheme(
        displayLarge: _createTextStyle(32, Colors.yellow),
        displayMedium: _createTextStyle(28, Colors.yellow),
        displaySmall: _createTextStyle(24, Colors.yellow),
        headlineMedium: _createTextStyle(22, Colors.yellow),
        headlineSmall: _createTextStyle(20, Colors.yellow),
        titleLarge: _createTextStyle(18, Colors.yellow),
        titleMedium: _createTextStyle(16, Colors.yellow),
        titleSmall: _createTextStyle(14, Colors.yellow),
        bodyLarge: _createTextStyle(16, Colors.yellow),
        bodyMedium: _createTextStyle(14, Colors.yellow),
        bodySmall: _createTextStyle(12, Colors.yellow),
        labelLarge: _createTextStyle(14, Colors.yellow),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.yellow,
          foregroundColor: Colors.black,
          textStyle: _createTextStyle(16, Colors.black),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Colors.black,
        titleTextStyle: _createTextStyle(20, Colors.yellow),
      ),
    );
  }

  ThemeData _buildHighContrastLightTheme() {
    return ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Color(0xFFF4F1EC),
      primaryColor: Color(0xFF1F2A44),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF1F2A44),
        onPrimary: Color(0xFFF4F1EC),
        surface: Color(0xFFF4F1EC),
        onSurface: Color(0xFF1F2A44),
        outline: Color(0xFF1F2A44),
      ),
      textTheme: TextTheme(
        displayLarge: _createTextStyle(32, Color(0xFF1F2A44)),
        displayMedium: _createTextStyle(28, Color(0xFF1F2A44)),
        displaySmall: _createTextStyle(24, Color(0xFF1F2A44)),
        headlineMedium: _createTextStyle(22, Color(0xFF1F2A44)),
        headlineSmall: _createTextStyle(20, Color(0xFF1F2A44)),
        titleLarge: _createTextStyle(18, Color(0xFF1F2A44)),
        titleMedium: _createTextStyle(16, Color(0xFF1F2A44)),
        titleSmall: _createTextStyle(14, Color(0xFF1F2A44)),
        bodyLarge: _createTextStyle(16, Color(0xFF1F2A44)),
        bodyMedium: _createTextStyle(14, Color(0xFF1F2A44)),
        bodySmall: _createTextStyle(12, Color(0xFF1F2A44)),
        labelLarge: _createTextStyle(14, Color(0xFF1F2A44)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color(0xFF1F2A44),
          foregroundColor: Color(0xFFF4F1EC),
          textStyle: _createTextStyle(16, Color(0xFFF4F1EC)),
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: Color(0xFFF4F1EC),
        titleTextStyle: _createTextStyle(20, Color(0xFF1F2A44)),
      ),
    );
  }

  TextStyle _createTextStyle(double baseSize, [Color? color]) {
    return TextStyle(
      fontSize: baseSize * _fontSizeMultiplier,
      letterSpacing: _letterSpacing,
      fontFamily: _isDyslexicFont ? _dyslexicFontType : null,
      color: color,
      fontWeight: _isHighContrast ? FontWeight.bold : null,
    );
  }
}