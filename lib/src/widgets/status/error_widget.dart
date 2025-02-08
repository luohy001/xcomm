import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

class ErrorWidget extends StatelessWidget {
  final Function()? onRefresh;
  final String? errorMsg;
  final TextStyle? errorStyle;

  const ErrorWidget({
    this.errorMsg,
    this.errorStyle,
    this.onRefresh,
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
            Lottie.asset(
              'assets/lottie/error.json',
              width: 0.6.sw,
              height: 0.6.sw,
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
