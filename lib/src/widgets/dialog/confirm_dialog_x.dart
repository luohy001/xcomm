import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xcomm/src/resources/resources.dart';
import 'package:xcomm/src/widgets/button_x.dart';
import 'package:xcomm/src/widgets/icon_x.dart';

enum ConfirmDialogXIconType {
  success,
  error,
}

class ConfirmDialogX extends StatelessWidget {
  final String title;
  final String? stringContent;
  final List<String>? stringListContent;
  final List<Widget>? widgetListContent;
  final TextStyle? contentsTextStyle;
  final String okText;
  final TextStyle? okTextStyle;
  final String cancelText;
  final TextStyle? cancelTextStyle;
  final Color? okBackgroundColor;
  final Color? okForegroundColor;
  final Color? cancelBackgroundColor;
  final Color? cancelForegroundColor;
  final double? borderRadius;
  final VoidCallback? onCancel;
  final VoidCallback? onOk;
  final ConfirmDialogXIconType? iconType;
  final bool showClose;
  final Widget? customIcon;
  final bool showOkButton;
  final bool showCancelButton;
  final String? tag;

  const ConfirmDialogX({
    super.key,
    this.stringContent,
    this.stringListContent,
    this.widgetListContent,
    this.contentsTextStyle,
    this.title = 'Confirmation',
    this.okText = 'Ok',
    this.okTextStyle,
    this.cancelText = 'Cancel',
    this.cancelTextStyle,
    this.okBackgroundColor,
    this.okForegroundColor,
    this.cancelBackgroundColor,
    this.cancelForegroundColor,
    this.borderRadius,
    this.onOk,
    this.onCancel,
    this.showClose = true,
    this.customIcon,
    this.showCancelButton = true,
    this.showOkButton = true,
    this.tag,
    this.iconType = ConfirmDialogXIconType.success,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 350.w,
      padding: REdgeInsets.symmetric(vertical: 16, horizontal: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius ?? 20.r),
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            //标题
            _buildTitle(),
            _buildIcon(),
            //更新信息
            _buildContents(),
            //操作按钮
            _buildAction()
          ],
        ),
      ),
    );
  }

  _buildTitle() {
    return Row(
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w600,
            color: ThemeColor.secondary,
          ),
        ),
        const Spacer(),
        Visibility(
          visible: showClose,
          child: GestureDetector(
            onTap: () => SmartDialog.dismiss(tag: tag),
            child: Icon(
              Icons.clear_outlined,
              size: 24.r,
              color: ThemeColor.primary,
            ),
          ),
        ),
      ],
    );
  }

  _buildIcon() {
    Widget? widget;
    if (customIcon != null) {
      widget = customIcon!;
    } else {
      var iconName = '';
      if (iconType == ConfirmDialogXIconType.error) {
        iconName = 'assets/svg/ico-warning.svg';
      } else if (iconType == ConfirmDialogXIconType.success) {
        iconName = 'assets/svg/ico-check.svg';
      }
      if (iconName.isEmpty) {
        widget = SizedBox.shrink();
      } else {
        widget = IconX.svg(
          iconName,
          size: 80.r,
          package: 'xcomm',
        );
      }
    }
    return Padding(
      padding: EdgeInsets.only(top: 24.r),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 200.r,
        ),
        child: widget,
      ),
    );
  }

  _buildContents() {
    List<Widget> children = [];
    if (widgetListContent != null) {
      children = widgetListContent!;
    } else if (stringListContent != null) {
      for (var text in stringListContent!) {
        children.add(
          Text(
            text,
            style: contentsTextStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  color: Colors.black,
                ),
          ),
        );
      }
    } else if (stringContent != null) {
      children.add(
        Text(
          stringContent!,
          style: contentsTextStyle ??
              TextStyle(
                fontSize: 14.sp,
                color: ThemeColor.secondary,
              ),
        ),
      );
    }
    return Container(
      padding: REdgeInsets.symmetric(vertical: 30),
      child: Column(
        children: children,
      ),
    );
  }

  _buildAction() {
    if (showOkButton && !showCancelButton) {
      return SizedBox(
        width: double.infinity,
        child: _buildOkActionButton(),
      );
    }
    if (showCancelButton && !showOkButton) {
      return SizedBox(
        width: double.infinity,
        child: _buildCancelActionButton(),
      );
    }
    if (showOkButton && showCancelButton) {
      return Row(
        children: [
          Expanded(child: _buildCancelActionButton()),
          RSizedBox(width: 24),
          Expanded(child: _buildOkActionButton()),
        ],
      );
    }
    return SizedBox.shrink();
  }

  _buildOkActionButton() {
    return ButtonX(
      okText,
      borderRadius: 37.r,
      onPressed: onOk,
      backgroundColor: okBackgroundColor ?? ThemeColor.primary,
      foregroundColor: okForegroundColor ?? Colors.white,
    );
  }

  _buildCancelActionButton() {
    return ButtonX.outline(
      cancelText,
      borderRadius: 37.r,
      onPressed: () => onCancel ?? SmartDialog.dismiss(tag: tag),
      backgroundColor: Colors.white,
      foregroundColor: okForegroundColor ?? ThemeColor.primary,
    );
  }
}
