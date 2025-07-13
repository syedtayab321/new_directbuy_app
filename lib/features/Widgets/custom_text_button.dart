import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'custom_text_widget.dart';

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final TextDecoration? decoration;
  final EdgeInsetsGeometry? padding;

  const CustomTextButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.color,
    this.fontWeight,
    this.fontSize,
    this.decoration,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        padding: padding,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: CustomTextWidget(
        text,
          color: color ?? AppColors.primary,
          fontWeight: fontWeight ?? FontWeight.w500,
          fontSize: fontSize ?? 14,
          decoration: decoration,
      ),
    );
  }
}