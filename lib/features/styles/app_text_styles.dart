import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextStyles {
  // Display
  static TextStyle displayLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 57,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle displayMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 45,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle displaySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 36,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  // Headline
  static TextStyle headlineLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 32,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle headlineMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 28,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle headlineSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 24,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  // Title
  static TextStyle titleLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 22,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle titleMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle titleSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  // Body
  static TextStyle bodyLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 16,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodyMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle bodySmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w400,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  // Label
  static TextStyle labelLarge(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle labelMedium(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }

  static TextStyle labelSmall(BuildContext context) {
    return GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w500,
      color: Theme.of(context).colorScheme.onBackground,
    );
  }
}