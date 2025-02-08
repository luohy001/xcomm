import 'package:flutter/material.dart';

//Android下不显示滚动列表的水波纹
class NoWaterRipplesAreDisplayed extends StatelessWidget {
  final Widget child;

  const NoWaterRipplesAreDisplayed({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: _EUMNoScrollBehavior(),
      child: child,
    );
  }
}

class _EUMNoScrollBehavior extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(
      BuildContext context, Widget child, ScrollableDetails details) {
    switch (getPlatform(context)) {
      case TargetPlatform.iOS:
        return child;
      case TargetPlatform.android:
      case TargetPlatform.fuchsia:
        return GlowingOverscrollIndicator(
          showLeading: false,
          // 不显示水波纹
          showTrailing: false,
          axisDirection: details.direction,
          color: Theme.of(context).colorScheme.secondary,
          child: child,
        );
      case TargetPlatform.linux:
        break;
      case TargetPlatform.macOS:
        break;
      case TargetPlatform.windows:
        break;
    }
    return child;
  }
}
