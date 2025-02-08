import 'package:flutter/material.dart';

class TitledDropdownItemEntity {
  String title;
  String value;
  String subtitle;

  TitledDropdownItemEntity({
    this.title = "",
    this.value = "",
    this.subtitle = "",
  });
}

class TitledDropdownItemAttribute {
  Widget? icon;
  Widget? selectedIcon;
  Color? selectedBgColor;
  Color? unselectedBgColor;
  Color? unselectedTitleColor;
  Color? selectedTitleColor;
  Color? selectedSubTitleColor;
  Color? unselectedSubTitleColor;
  LinearGradient? linearGradient;
  BorderRadiusGeometry? borderRadius;
  final BoxBorder? border;

  TitledDropdownItemAttribute({
    this.icon,
    this.selectedIcon,
    this.selectedBgColor,
    this.unselectedBgColor,
    this.selectedTitleColor,
    this.unselectedTitleColor,
    this.unselectedSubTitleColor,
    this.selectedSubTitleColor,
    this.linearGradient,
    this.borderRadius,
    this.border
  });
}

class TitledDropdownDialogAttribute {
  String title;
  String subtitle;
  double? maxHeight;
  final Color? closeIconColor;
  final double? closeIconSize;
  TextStyle? titleStyle;
  TextStyle? subtitleStyle;

  TitledDropdownDialogAttribute({
    this.title = "",
    this.subtitle = "",
    this.maxHeight,
    this.titleStyle,
    this.subtitleStyle,
    this.closeIconSize,
    this.closeIconColor,
  });
}
