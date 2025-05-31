import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ErrorStatusWidget extends StatelessWidget {
  final Function()? onRefresh;
  final String? errorMsg;
  final TextStyle? errorStyle;
  final Widget? icon;

  const ErrorStatusWidget({
    this.errorMsg,
    this.errorStyle,
    this.onRefresh,
    this.icon,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        onTap: () {
          onRefresh?.call();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            icon ??
                Lottie.asset(
                  'assets/lottie/error.json',
                  width: 0.6.sw,
                  height: 0.6.sw,
                  package: 'xcomm',
                ),
            SizedBox(height: 5.r),
            Text(
              errorMsg ?? 'system error',
              textAlign: TextAlign.center,
              style: errorStyle ??
                  TextStyle(
                    fontSize: 14.r,
                    color: Colors.grey,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
