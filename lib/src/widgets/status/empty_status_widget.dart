import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../text_x.dart';

class EmptyStatusWidget extends StatelessWidget {
  final Function()? onRefresh;
  final String? emptyMessage;
  final Widget? icon;

  const EmptyStatusWidget({
    this.onRefresh,
    this.emptyMessage,
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
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              icon ??
                  Lottie.asset(
                    'assets/lottie/empty.json',
                    width: 0.6.sw,
                    height: 0.6.sw,
                    package: 'xcomm',
                  ),
              TextX.labelMedium(emptyMessage ?? 'No data, click retry'),
            ],
          ),
        ),
      ),
    );
  }
}
