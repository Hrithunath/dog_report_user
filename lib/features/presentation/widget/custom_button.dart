import 'package:flutter/material.dart';

class ButtonCustomized extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final TextStyle? textStyle;
  final double borderRadius;
  final double? width;
  final double? height;
  final Icon? icon;
  const ButtonCustomized(
      {super.key,
      required this.text,
      required this.onPressed,
      this.color,
      this.textStyle,
      this.borderRadius = 8.0,
      this.width,
      this.height,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton.icon(
          icon: icon,
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(borderRadius),
            ),
          ),
          label: Text(
            text,
            style: const TextStyle(
                color: Colors.white, fontSize: 20, fontWeight: FontWeight.w500),
          )),
    );
  }
}
