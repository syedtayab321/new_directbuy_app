import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/app_colors.dart';

class CustomTextWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;
  final Color? color;
  final FontWeight? fontWeight;
  final double? fontSize;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;
  final bool? softWrap;
  final TextDecoration? decoration;
  final Color? decorationColor;
  final TextDecorationStyle? decorationStyle;
  final double? decorationThickness;
  final FontStyle? fontStyle;
  final List<Shadow>? shadows;
  final Paint? foreground;
  final bool usePoppins;

  const CustomTextWidget(
      this.text, {
        super.key,
        this.style,
        this.color,
        this.fontWeight,
        this.fontSize,
        this.letterSpacing,
        this.wordSpacing,
        this.height,
        this.textAlign,
        this.maxLines,
        this.overflow,
        this.softWrap,
        this.decoration,
        this.decorationColor,
        this.decorationStyle,
        this.decorationThickness,
        this.fontStyle,
        this.shadows,
        this.foreground,
        this.usePoppins = true,
      });

  @override
  Widget build(BuildContext context) {
    final defaultStyle = usePoppins
        ? GoogleFonts.poppins(
      color: color ?? AppColors.onBackground,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize ?? 14,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontStyle: fontStyle,
      shadows: shadows,
      foreground: foreground,
    )
        : TextStyle(
      color: color ?? AppColors.onBackground,
      fontWeight: fontWeight ?? FontWeight.normal,
      fontSize: fontSize ?? 14,
      letterSpacing: letterSpacing,
      wordSpacing: wordSpacing,
      height: height,
      decoration: decoration,
      decorationColor: decorationColor,
      decorationStyle: decorationStyle,
      decorationThickness: decorationThickness,
      fontStyle: fontStyle,
      shadows: shadows,
      foreground: foreground,
    );

    return Text(
      text,
      style: style?.copyWith(
        color: color,
        fontWeight: fontWeight,
        fontSize: fontSize,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        height: height,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        fontStyle: fontStyle,
        shadows: shadows,
        foreground: foreground,
      ) ??
          defaultStyle,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
      softWrap: softWrap,
    );
  }
}