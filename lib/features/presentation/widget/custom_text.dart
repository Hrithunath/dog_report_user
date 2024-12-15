import 'package:flutter/material.dart';

class TextCustom extends StatelessWidget {
  final String text;
  final double? fontSize;
  final FontWeight? fontWeight;
  final Color? color;
  final FontStyle? fontStyle;
  final double? letterSpacing;
  final double? wordSpacing;
  final double? height;
  final TextAlign? textAlign;
  final String? fontFamily;
  final VoidCallback? onTap;
  final TextOverflow? overflow;

  const TextCustom({
    super.key,
    required this.text,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.fontStyle,
    this.letterSpacing,
    this.wordSpacing,
    this.height,
    this.textAlign,
    this.fontFamily,
    this.onTap,
    this.overflow,
  });

  @override
  Widget build(BuildContext context) {
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: Text(
          text,
          style: TextStyle(
            fontSize: fontSize,
            fontWeight: fontWeight,
            color: color,
            fontStyle: fontStyle,
            letterSpacing: letterSpacing,
            wordSpacing: wordSpacing,
            height: height,
            fontFamily: fontFamily,
          ),
          textAlign: textAlign,
          overflow: overflow,
          softWrap: true,
        ),
      );
    } else {
      return Text(
        text,
        style: TextStyle(
          fontSize: fontSize,
          fontWeight: fontWeight,
          color: color,
          fontStyle: fontStyle,
          letterSpacing: letterSpacing,
          wordSpacing: wordSpacing,
          height: height,
          fontFamily: fontFamily,
        ),
        textAlign: textAlign,
        overflow: overflow,
        softWrap: true,
      );
    }
  }
}
