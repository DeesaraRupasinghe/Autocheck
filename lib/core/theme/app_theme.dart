import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// AutoCheck app theme configuration using Material 3
/// Design System:
/// - Primary: Electric Blue #2563EB
/// - Secondary/Text: Slate Dark #1E293B
/// - Success: Emerald Green #10B981
/// - Error: Rose Red #E11D48
/// - Background: Off-white #F8FAFC
/// - Surface/Cards: Pure White #FFFFFF
/// - Border Radius: 16.0 globally
/// - Typography: Poppins (headings) + Inter (body)
class AppTheme {
  // Design System Colors
  static const Color primaryColor = Color(0xFF2563EB);    // Electric Blue
  static const Color secondaryColor = Color(0xFF1E293B);  // Slate Dark
  static const Color errorColor = Color(0xFFE11D48);      // Rose Red
  static const Color warningColor = Color(0xFFFFA726);    // Amber (warning)
  static const Color successColor = Color(0xFF10B981);    // Emerald Green
  static const Color backgroundColor = Color(0xFFF8FAFC); // Off-white
  static const Color surfaceColor = Color(0xFFFFFFFF);    // Pure White

  // Risk level colors
  static const Color riskGreen = Color(0xFF10B981);  // Emerald Green
  static const Color riskYellow = Color(0xFFFFC107); // Amber
  static const Color riskRed = Color(0xFFE11D48);    // Rose Red

  // Global border radius
  static const double borderRadius = 16.0;

  // Spacing constants (8px rhythm)
  static const double spacingXs = 4.0;
  static const double spacingSm = 8.0;
  static const double spacingMd = 16.0;
  static const double spacingLg = 24.0;
  static const double spacingXl = 32.0;

  // Min touch target size for accessibility
  static const double minTouchTarget = 48.0;

  // Text Theme using Google Fonts
  static TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith(
      // Screen titles: 22–24sp (Poppins Bold)
      headlineLarge: GoogleFonts.poppins(
        textStyle: base.headlineLarge,
        fontWeight: FontWeight.bold,
        fontSize: 24,
      ),
      headlineMedium: GoogleFonts.poppins(
        textStyle: base.headlineMedium,
        fontWeight: FontWeight.bold,
        fontSize: 22,
      ),
      headlineSmall: GoogleFonts.poppins(
        textStyle: base.headlineSmall,
        fontWeight: FontWeight.w600,
        fontSize: 20,
      ),
      // Section titles: 16–18sp (Poppins SemiBold)
      titleLarge: GoogleFonts.poppins(
        textStyle: base.titleLarge,
        fontWeight: FontWeight.w600,
        fontSize: 18,
      ),
      titleMedium: GoogleFonts.poppins(
        textStyle: base.titleMedium,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
      titleSmall: GoogleFonts.poppins(
        textStyle: base.titleSmall,
        fontWeight: FontWeight.w600,
        fontSize: 14,
      ),
      // Body text: 14–16sp (Inter Regular/Medium)
      bodyLarge: GoogleFonts.inter(
        textStyle: base.bodyLarge,
        fontWeight: FontWeight.normal,
        fontSize: 16,
      ),
      bodyMedium: GoogleFonts.inter(
        textStyle: base.bodyMedium,
        fontWeight: FontWeight.normal,
        fontSize: 14,
      ),
      bodySmall: GoogleFonts.inter(
        textStyle: base.bodySmall,
        fontWeight: FontWeight.normal,
        fontSize: 12,
      ),
      // Labels/Captions: 12–13sp (Inter)
      labelLarge: GoogleFonts.inter(
        textStyle: base.labelLarge,
        fontWeight: FontWeight.w500,
        fontSize: 14,
      ),
      labelMedium: GoogleFonts.inter(
        textStyle: base.labelMedium,
        fontWeight: FontWeight.w500,
        fontSize: 12,
      ),
      labelSmall: GoogleFonts.inter(
        textStyle: base.labelSmall,
        fontWeight: FontWeight.w500,
        fontSize: 11,
      ),
    );
  }

  // Light theme configuration
  static ThemeData get lightTheme {
    final base = ThemeData.light(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme);
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: ColorScheme.light(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: secondaryColor,
        onSecondary: Colors.white,
        error: errorColor,
        onError: Colors.white,
        surface: surfaceColor,
        onSurface: secondaryColor,
        onSurfaceVariant: secondaryColor.withValues(alpha: 0.7),
      ),
      scaffoldBackgroundColor: backgroundColor,
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: backgroundColor,
        foregroundColor: secondaryColor,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: surfaceColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        shadowColor: secondaryColor.withValues(alpha: 0.08),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(minTouchTarget, minTouchTarget),
          textStyle: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: secondaryColor.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: secondaryColor.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: errorColor),
        ),
        filled: true,
        fillColor: surfaceColor,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        labelStyle: GoogleFonts.inter(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          color: secondaryColor.withValues(alpha: 0.7),
        ),
        hintStyle: GoogleFonts.inter(
          fontSize: 14,
          color: secondaryColor.withValues(alpha: 0.5),
        ),
      ),
      chipTheme: ChipThemeData(
        shape: const StadiumBorder(),
        backgroundColor: primaryColor.withValues(alpha: 0.1),
        labelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: surfaceColor,
        selectedItemColor: primaryColor,
        unselectedItemColor: secondaryColor.withValues(alpha: 0.5),
        elevation: 8,
        selectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
        unselectedLabelStyle: GoogleFonts.inter(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
      dividerTheme: DividerThemeData(
        color: secondaryColor.withValues(alpha: 0.1),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: secondaryColor,
        contentTextStyle: GoogleFonts.inter(
          fontSize: 14,
          color: Colors.white,
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: surfaceColor,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: secondaryColor,
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryColor,
      ),
    );
  }

  // Dark theme configuration
  static ThemeData get darkTheme {
    final base = ThemeData.dark(useMaterial3: true);
    final textTheme = _buildTextTheme(base.textTheme);
    
    const darkBackground = Color(0xFF0F172A);  // Very dark blue
    const darkSurface = Color(0xFF1E293B);     // Slate dark
    const darkOnSurface = Color(0xFFF1F5F9);   // Light gray
    
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: ColorScheme.dark(
        primary: primaryColor,
        onPrimary: Colors.white,
        secondary: darkOnSurface,
        onSecondary: darkBackground,
        error: errorColor,
        onError: Colors.white,
        surface: darkSurface,
        onSurface: darkOnSurface,
        onSurfaceVariant: darkOnSurface.withValues(alpha: 0.7),
      ),
      scaffoldBackgroundColor: darkBackground,
      textTheme: textTheme.apply(
        bodyColor: darkOnSurface,
        displayColor: darkOnSurface,
      ),
      appBarTheme: AppBarTheme(
        centerTitle: true,
        elevation: 0,
        scrolledUnderElevation: 1,
        backgroundColor: darkBackground,
        foregroundColor: darkOnSurface,
        titleTextStyle: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: darkOnSurface,
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: darkSurface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: Colors.white,
          minimumSize: const Size(double.infinity, minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          elevation: 0,
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryColor,
          minimumSize: const Size(double.infinity, minTouchTarget),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          side: BorderSide(color: primaryColor.withValues(alpha: 0.5)),
          textStyle: GoogleFonts.inter(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: darkOnSurface.withValues(alpha: 0.2)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: BorderSide(color: darkOnSurface.withValues(alpha: 0.2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(borderRadius),
          borderSide: const BorderSide(color: primaryColor, width: 2),
        ),
        filled: true,
        fillColor: darkSurface,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        type: BottomNavigationBarType.fixed,
        showUnselectedLabels: true,
        backgroundColor: darkSurface,
        selectedItemColor: primaryColor,
        unselectedItemColor: darkOnSurface.withValues(alpha: 0.5),
      ),
      dividerTheme: DividerThemeData(
        color: darkOnSurface.withValues(alpha: 0.1),
        thickness: 1,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      dialogTheme: DialogThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: darkSurface,
      ),
    );
  }

  /// Creates a soft box shadow for cards (light mode)
  static List<BoxShadow> get softShadow => [
    BoxShadow(
      color: secondaryColor.withValues(alpha: 0.08),
      blurRadius: 16,
      offset: const Offset(0, 4),
    ),
  ];

  /// Creates a subtle box shadow for elevated elements
  static List<BoxShadow> get subtleShadow => [
    BoxShadow(
      color: secondaryColor.withValues(alpha: 0.05),
      blurRadius: 8,
      offset: const Offset(0, 2),
    ),
  ];
}
