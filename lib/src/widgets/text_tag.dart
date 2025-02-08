import 'package:flutter/material.dart';
import 'package:xcomm/xcomm.dart';

/// 文本标签
class TextTag extends StatelessWidget {
  final String text;
  final Color? color;
  final bool outline;

  const TextTag(
      this.text, {
        super.key,
        this.color,
        this.outline = false,
      });

  @override
  Widget build(BuildContext context) {
    if (outline) {
      return TextX.labelSmall(
        text,
        color: color ?? ThemeColor.primary,
        weight: FontWeight.w500,
      )
          .padding(
        horizontal: 10.w,
        vertical: 4.h,
      )
          .border(
        radius: 5.r,
        color: color ?? ThemeColor.primary,
        all: 1.4,
      );
    } else {
      return TextX.labelSmall(
        text,
        color: Colors.white,
        weight: FontWeight.bold,
      )
          .padding(
        horizontal: 10.w,
        vertical: 4.h,
      )
          .border(
        radius: 5.r,
        backgroundColor: color ?? ThemeColor.primary,
      );
    }
  }
}