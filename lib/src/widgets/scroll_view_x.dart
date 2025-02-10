import 'package:flutter/material.dart';

/// 本项目通用的布局（SingleChildScrollView）
/// 1.底部存在按钮
/// 2.底部没有按钮

class ScrollViewX extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry? padding;
  final ScrollPhysics physics;
  final CrossAxisAlignment crossAxisAlignment;
  final Widget? bottomButton;

  const ScrollViewX({
    super.key,
    required this.children,
    this.padding,
    this.physics = const BouncingScrollPhysics(),
    this.crossAxisAlignment = CrossAxisAlignment.start,
    this.bottomButton,
  });

  @override
  Widget build(BuildContext context) {
    Widget contents = SingleChildScrollView(
      padding: padding,
      physics: physics,
      child: Column(
        crossAxisAlignment: crossAxisAlignment,
        children: children,
      ),
    );

    if (bottomButton != null) {
      contents = Column(
        children: <Widget>[
          Expanded(child: contents),
          SafeArea(child: bottomButton!)
        ],
      );
    }
    return contents;
  }
}
