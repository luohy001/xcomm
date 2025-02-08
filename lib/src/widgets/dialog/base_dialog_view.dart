import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

import '../no_water_ripples_are_displayed.dart';

class BaseDialogView extends StatelessWidget {
  final Widget child;
  final double? height;
  final String title;
  final TextStyle? titleStyle;
  final String subTitle;
  final TextStyle? subTitleStyle;
  final AlignmentGeometry titleAlign;
  final Widget? bottomWidget;
  final Color? closeIconColor;
  final double? closeIconSize;

  const BaseDialogView({
    super.key,
    required this.child,
    this.height,
    this.bottomWidget,
    this.title = '',
    this.subTitle = '',
    this.titleStyle,
    this.subTitleStyle,
    this.closeIconColor,
    this.closeIconSize,
    this.titleAlign = Alignment.topCenter,
  });

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: height ?? 0.6.sh),
      child: Container(
        padding: REdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.r),
            topLeft: Radius.circular(20.r),
          ),
          boxShadow: [
            BoxShadow(
              color: Color.fromRGBO(0, 0, 0, 0.25),
              offset: Offset(0, -8),
              blurRadius: 8,
              spreadRadius: 0,
            )
          ],
        ),
        child: SafeArea(
          top: false,
          child: IntrinsicHeight(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Stack(
                  children: [
                    FractionallySizedBox(
                      widthFactor: 1,
                      child: Container(
                        padding:
                            REdgeInsets.only(left: 22, right: 22, bottom: 15),
                        alignment: titleAlign,
                        child: Text(
                          title,
                          style: titleStyle ??
                              TextStyle(
                                fontSize: 18.sp,
                                color: Color(0xFF00348A),
                              ),
                        ),
                      ),
                    ),
                    Positioned(
                      right: 30,
                      top: 0,
                      child: GestureDetector(
                        onTap: () => SmartDialog.dismiss(),
                        child: Icon(
                          Icons.clear_outlined,
                          color: closeIconColor ?? Colors.black,
                          size: closeIconSize ?? 22.r,
                        ),
                      ),
                    ),
                  ],
                ),
                if (subTitle.isNotEmpty)
                  Padding(
                    padding: REdgeInsets.only(left: 22, right: 22, bottom: 10),
                    child: Text(
                      subTitle,
                      style: subTitleStyle ??
                          TextStyle(
                            color: const Color(0xFF29246C),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                          ),
                    ),
                  ),
                Expanded(
                  child: NoWaterRipplesAreDisplayed(
                    child: SingleChildScrollView(child: child),
                  ),
                ),
                bottomWidget ?? const SizedBox.shrink()
              ],
            ),
          ),
        ),
      ),
    );
  }
}
