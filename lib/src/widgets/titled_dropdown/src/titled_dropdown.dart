import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:xcomm/src/widgets/dialog/base_dialog_view.dart';
import 'package:xcomm/src/extensions/ex_string.dart';
import 'attribute.dart';

class TitledDropdown extends StatefulWidget {
  final List<TitledDropdownItemEntity> options;
  final TitledDropdownItemAttribute? itemAttribute;
  final TitledDropdownDialogAttribute? dialogAttribute;
  final ValueChanged<TitledDropdownItemEntity>? onSelectedCallBack;
  final String? hintText;
  final String? title;
  final TextStyle? hintTextStyle;
  final TextStyle? labelTextStyle;
  final double? dialogHeight;
  final String initValue;
  final TextStyle? titleStyle;
  final EdgeInsetsGeometry? padding;
  final Function? emptyOptionHandle;
  final bool loading;
  final Widget? leading;
  final bool clickMaskDismiss;

  const TitledDropdown({
    super.key,
    required this.options,
    this.dialogAttribute,
    this.title,
    this.hintText,
    this.titleStyle,
    this.hintTextStyle,
    this.labelTextStyle,
    this.onSelectedCallBack,
    this.padding,
    this.dialogHeight,
    this.emptyOptionHandle,
    this.initValue = '',
    this.itemAttribute,
    this.loading = false,
    this.leading,
    this.clickMaskDismiss = false,
  });

  @override
  TitledDropdownState createState() => TitledDropdownState();
}

class TitledDropdownState extends State<TitledDropdown> {
  final ValueNotifier<TitledDropdownItemEntity> selectedOption =
      ValueNotifier<TitledDropdownItemEntity>(
    TitledDropdownItemEntity(),
  );
  late TitledDropdownItemEntity submitOption;
  late TitledDropdownDialogAttribute dialogAttribute;
  late TitledDropdownItemAttribute itemAttribute;

  @override
  void initState() {
    dialogAttribute = widget.dialogAttribute ?? TitledDropdownDialogAttribute();
    itemAttribute = widget.itemAttribute ?? TitledDropdownItemAttribute();
    if (widget.initValue.isNotEmpty) {
      selectedOption.value = widget.options.firstWhere(
        (element) => element.value == widget.initValue,
        orElse: () => TitledDropdownItemEntity(),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.title.isNotEmptyOrNull)
          Text(
            widget.title!,
            style: widget.titleStyle ??
                TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xff29246C),
                ),
          ),
        const RSizedBox(height: 10),
        InkWell(
          splashFactory: NoSplash.splashFactory,
          onTap: _showBottomSheet,
          child: Container(
            decoration: BoxDecoration(
              color: widget.options.isEmpty
                  ? const Color(0xFFE4E3F7)
                  : Colors.white,
              border: Border.all(
                color: const Color(0xFF9692C8),
              ),
              borderRadius: BorderRadius.circular(90.r),
            ),
            padding: widget.padding ??
                REdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (widget.leading != null)
                  Padding(
                    padding: EdgeInsets.only(right: 5.r),
                    child: ConstrainedBox(
                      constraints:
                          BoxConstraints(maxWidth: 24.r, minHeight: 24.r),
                      child: widget.leading,
                    ),
                  ),
                Expanded(
                  child: ValueListenableBuilder<TitledDropdownItemEntity>(
                    builder: (context, value, child) {
                      if (value.title.isEmpty) {
                        return Text(
                          widget.hintText ?? 'Select',
                          style: widget.hintTextStyle ??
                              TextStyle(
                                color: const Color(0xFF9692C8),
                                fontSize: 14.sp,
                              ),
                        );
                      }
                      return Text(
                        selectedOption.value.title,
                        style: widget.labelTextStyle ??
                            TextStyle(
                              color: const Color(0xFF29246C),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                            ),
                      );
                    },
                    valueListenable: selectedOption,
                  ),
                ),
                if (widget.loading)
                  const CupertinoActivityIndicator(radius: 12)
                else
                  const Icon(
                    Icons.expand_more,
                    color: Color(0xFF9692C8),
                  )
              ],
            ),
          ),
        )
      ],
    );
  }

  void _showBottomSheet() {
    if (widget.options.isEmpty) {
      if (widget.emptyOptionHandle == null) {
        return;
      }
      widget.emptyOptionHandle?.call();
      return;
    }
    SmartDialog.show(
      builder: (_) => BaseDialogView(
        height: widget.dialogHeight,
        title: dialogAttribute.title,
        titleStyle: dialogAttribute.titleStyle,
        subTitleStyle: dialogAttribute.subtitleStyle,
        subTitle: dialogAttribute.subtitle,
        closeIconColor: dialogAttribute.closeIconColor,
        closeIconSize: dialogAttribute.closeIconSize,
        titleAlign: Alignment.centerLeft,
        child: Container(
          margin: REdgeInsets.symmetric(horizontal: 22, vertical: 10),
          child: ValueListenableBuilder<TitledDropdownItemEntity>(
            builder: (context, value, child) => Column(
              children: widget.options
                  .map((element) => _buildSelectItem(element))
                  .toList(),
            ),
            valueListenable: selectedOption,
          ),
        ),
      ),
      clickMaskDismiss: widget.clickMaskDismiss,
      alignment: Alignment.bottomLeft,
    );
  }

  Widget _buildSelectItem(TitledDropdownItemEntity item) {
    return InkWell(
      splashFactory: NoSplash.splashFactory,
      onTap: () {
        if (selectedOption.value == item) {
          selectedOption.value = TitledDropdownItemEntity();
          widget.onSelectedCallBack?.call(selectedOption.value);
          SmartDialog.dismiss();
          return;
        }
        selectedOption.value = item;
        widget.onSelectedCallBack?.call(selectedOption.value);
        SmartDialog.dismiss();
      },
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Container(
          margin: REdgeInsets.only(bottom: 10),
          padding: REdgeInsets.symmetric(horizontal: 12, vertical: 16),
          decoration: BoxDecoration(
            color: selectedOption.value.value == item.value
                ? itemAttribute.selectedBgColor
                : itemAttribute.unselectedBgColor,
            gradient: selectedOption.value.value == item.value
                ? itemAttribute.linearGradient
                : null,
            borderRadius: itemAttribute.borderRadius ??
                BorderRadius.all(
                  Radius.circular(10.r),
                ),
            border: itemAttribute.border,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (itemAttribute.icon != null)
                Padding(
                  padding: EdgeInsets.only(right: 8.r),
                  child: selectedOption.value.value == item.value
                      ? (itemAttribute.selectedIcon ?? itemAttribute.icon)
                      : itemAttribute.icon,
                ),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: selectedOption.value.value == item.value
                          ? TextStyle(
                              color: itemAttribute.selectedTitleColor ??
                                  Colors.white,
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            )
                          : TextStyle(
                              color: itemAttribute.unselectedTitleColor ??
                                  Color(0xFF29246C),
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                            ),
                    ),
                    if (item.subtitle.isNotEmptyOrNull)
                      Text(
                        item.subtitle,
                        style: selectedOption.value.value == item.value
                            ? TextStyle(
                                color: itemAttribute.selectedSubTitleColor ??
                                    Colors.white,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              )
                            : TextStyle(
                                color: itemAttribute.unselectedSubTitleColor ??
                                    Color(0xFF8F8CD6),
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                              ),
                      ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
