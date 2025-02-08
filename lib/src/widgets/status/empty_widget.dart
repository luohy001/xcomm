import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:lottie/lottie.dart';

import '../text_x.dart';

class EmptyWidget extends StatelessWidget {
  final Function()? onRefresh;
  final String? emptyMessage;

  const EmptyWidget({
    this.onRefresh,
    this.emptyMessage,
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
              Lottie.asset(
                'assets/lottie/error.json',
                width: 0.6.sw,
                height: 0.6.sw,
              ),
              TextX.labelMedium(emptyMessage ?? 'No data, click retry'),
            ],
          ),
        ),
      ),
    );
  }
}
