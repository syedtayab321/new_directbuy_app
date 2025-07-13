import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class BackgroundGradient extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;
  final AlignmentGeometry begin;
  final AlignmentGeometry end;

  const BackgroundGradient({
    super.key,
    required this.child,
    this.colors,
    this.begin = Alignment.topCenter,
    this.end = Alignment.bottomCenter,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: begin,
          end: end,
          colors: colors ??
              [
                AppColors.primary.withOpacity(0.8),
                AppColors.primary,
              ],
        ),
      ),
      child: child,
    );
  }
}