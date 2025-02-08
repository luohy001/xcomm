import 'dart:async';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'event/refresh_ui.dart';
import 'services/global.dart';

/// 插件包名
const String pluginPackageName = 'xcomm';

late final bool isDebugMode;

/// 初始化脚手架
Future<WidgetsBinding> xcommInit({
  bool isDebug = false,
  List<Locale>? supportedLocales,
}) async {
  isDebugMode = isDebug;
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Get.putAsync(() => GlobalService().init(
    supportedLocales: supportedLocales,
  ));
  return widgetsBinding;
}

/// 延时执行
void delayed(int milliseconds, Function() callback) {
  Future.delayed(Duration(milliseconds: milliseconds), callback);
}

/// 返回全局事件总线
EventBus get eventBus => GlobalService.to.eventBus;

/// 监听事件总线
StreamSubscription<T> eventListen<T>(
    void Function(T)? onData, {
      Function? onError,
      void Function()? onDone,
      bool? cancelOnError,
    }) {
  return eventBus.on<T>().listen(
    onData,
    onError: onError,
    onDone: onDone,
    cancelOnError: cancelOnError,
  );
}

/// 发送事件总线
sendEvent<T>(T event) {
  eventBus.fire(event);
}

/// 刷新App所有页面
void refreshAppUi() {
  sendEvent(const RefreshUiEvent());
}

/// 返回sharedPreferences
SharedPreferences get sharedPreferences => GlobalService.to.sharedPreferences;

/// 切换主题模式
void changeThemeMode(ThemeMode themeMode) {
  GlobalService.to.changeThemeMode(themeMode);
}

/// 更改语言
void changeLanguage(Locale locale) {
  GlobalService.to.changeLocale(locale);
}

// 进入全屏模式(隐藏状态栏和导航栏)
void enterFullScreen() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
}

// 取消全屏设置为正常状态(现在状态栏和导航栏可见)
void exitFullScreen() {
  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.manual,
    overlays: SystemUiOverlay.values,
  );
}

///设置方向为纵向
void setOrientationPortrait() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp,
  ]);
}

/// 设定景观方向
void setOrientationLandscape() {
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);
}
