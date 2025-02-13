import 'package:flutter/material.dart';

class ColoredSafeArea extends StatelessWidget {
  final Widget child;
  final Color? color;
  final bool top;
  final bool bottom;

  const ColoredSafeArea({
    super.key,
    required this.child,
    this.color,
    this.top = true,
    this.bottom = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: color ?? Theme.of(context).colorScheme.primaryContainer,
      child: SafeArea(
        top: top,
        bottom: bottom,
        child: child,
      ),
    );
  }
}
