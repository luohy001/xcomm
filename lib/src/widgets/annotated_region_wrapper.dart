import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

//修改状态栏的颜色，白和黑
class AnnotatedRegionWrapper extends StatelessWidget {
  final Widget child;
  final bool isLight;
  final Color systemNavigationBarColor;

  const AnnotatedRegionWrapper(
      {super.key,
      required this.child,
      this.isLight = true,
      this.systemNavigationBarColor = const Color(0xFFFFFFFF)});

  @override
  Widget build(BuildContext context) {
    SystemUiOverlayStyle overlayStyle = isLight
        ? SystemUiOverlayStyle(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.light,
            statusBarBrightness: Brightness.dark,
          )
        : SystemUiOverlayStyle(
            systemNavigationBarColor: systemNavigationBarColor,
            systemNavigationBarIconBrightness: Brightness.light,
            statusBarIconBrightness: Brightness.dark,
            statusBarBrightness: Brightness.light,
          );
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: child,
    );
  }
}
