import 'package:flutter/material.dart';
import 'package:xcomm/xcomm.dart';

class LoadingStatusWidget extends StatelessWidget {
  const LoadingStatusWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitFadingCube(
        size: 22.r,
        color: ThemeColor.primary,
      ),
    );
  }
}
