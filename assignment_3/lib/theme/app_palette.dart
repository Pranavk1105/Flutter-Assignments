import 'package:flutter/material.dart';

class AppPalette {
  AppPalette._();

  static const Color gradientStart = Color(0xFF6D28D9); // deep violet
  static const Color gradientEnd = Color(0xFF0D9488); // teal
  static const Color star = Color(0xFFF59E0B);

  static const _lightBackground = Color(0xFFF5F3FF);
  static const _lightSurface = Color(0xFFFFFFFF);
  static const _lightCardBorder = Color(0xFFE5E1F5);
  static const _lightTextPrimary = Color(0xFF1E1B29);
  static const _lightTextSecondary = Color(0xFF635E75);

  static const _darkBackground = Color(0xFF14121F);
  static const _darkSurface = Color(0xFF1E1B2E);
  static const _darkCardBorder = Color(0xFF322C48);
  static const _darkTextPrimary = Color(0xFFF3F1FA);
  static const _darkTextSecondary = Color(0xFFA79FC2);

  static ThemeData light() => _buildTheme(
        brightness: Brightness.light,
        background: _lightBackground,
        surface: _lightSurface,
        cardBorder: _lightCardBorder,
        textPrimary: _lightTextPrimary,
        textSecondary: _lightTextSecondary,
      );

  static ThemeData dark() => _buildTheme(
        brightness: Brightness.dark,
        background: _darkBackground,
        surface: _darkSurface,
        cardBorder: _darkCardBorder,
        textPrimary: _darkTextPrimary,
        textSecondary: _darkTextSecondary,
      );

  static ThemeData _buildTheme({
    required Brightness brightness,
    required Color background,
    required Color surface,
    required Color cardBorder,
    required Color textPrimary,
    required Color textSecondary,
  }) {
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: gradientStart,
        brightness: brightness,
        primary: gradientStart,
        secondary: gradientEnd,
        surface: surface,
      ),
      extensions: [
        AppPaletteExtension(
          background: background,
          surface: surface,
          cardBorder: cardBorder,
          textPrimary: textPrimary,
          textSecondary: textSecondary,
        ),
      ],
    );
  }
}

@immutable
class AppPaletteExtension extends ThemeExtension<AppPaletteExtension> {
  final Color background;
  final Color surface;
  final Color cardBorder;
  final Color textPrimary;
  final Color textSecondary;

  const AppPaletteExtension({
    required this.background,
    required this.surface,
    required this.cardBorder,
    required this.textPrimary,
    required this.textSecondary,
  });

  @override
  AppPaletteExtension copyWith({
    Color? background,
    Color? surface,
    Color? cardBorder,
    Color? textPrimary,
    Color? textSecondary,
  }) {
    return AppPaletteExtension(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      cardBorder: cardBorder ?? this.cardBorder,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
    );
  }

  @override
  AppPaletteExtension lerp(
    ThemeExtension<AppPaletteExtension>? other,
    double t,
  ) {
    if (other is! AppPaletteExtension) return this;
    return AppPaletteExtension(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      cardBorder: Color.lerp(cardBorder, other.cardBorder, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
    );
  }
}

extension AppPaletteContext on BuildContext {
  AppPaletteExtension get palette =>
      Theme.of(this).extension<AppPaletteExtension>()!;
}
