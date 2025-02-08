import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

/// 返回回调
typedef DoubleTapBackExitAppBackCallback = Future<bool> Function();

/// DoublePressBackWidget
// ignore: must_be_immutable
class DoubleTapBackExitApp extends StatelessWidget {
  final Widget child;
  final String? message;
  final DoubleTapBackExitAppBackCallback? backCallback;

  DateTime? _currentBackPressTime;

  DoubleTapBackExitApp({
    super.key,
    required this.child,
    this.message,
    this.backCallback,
  });

  // 返回键退出
  bool closeOnConfirm() {
    DateTime now = DateTime.now();
    if (_currentBackPressTime == null ||
        now.difference(_currentBackPressTime!) > const Duration(seconds: 2)) {
      _currentBackPressTime = now;
      SmartDialog.showToast(message ?? 'Press back again to exit');
      return false;
    }
    _currentBackPressTime = null;
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, value) async {
        if (didPop) {
          return;
        }
        if (closeOnConfirm()) {
          if (backCallback != null) {
            if (!await backCallback!()) {
              return;
            }
          }
          SystemNavigator.pop();
        }
      },
      child: child,
    );
  }
}
