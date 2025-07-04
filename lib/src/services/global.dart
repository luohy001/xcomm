import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:xcomm/xcomm.dart';

/// 语言改变的回调
typedef LocaleChangeCallback = Function(Locale locale);

/// 全局服务
class GlobalService extends GetxService with WidgetsBindingObserver {
  static GlobalService get to => Get.find();
  late EventBus eventBus;
  BaseDeviceInfo? _baseDeviceInfo;

  static const String themeCodeKey = 'themeCodeKey';
  static const String languageCodeKey = 'languageCodeKey';

  //主题
  ThemeMode _themeMode = ThemeMode.system;

  ThemeMode get themeMode => _themeMode;

  //语言
  Locale locale = PlatformDispatcher.instance.locale;
  LocaleChangeCallback? localeChangeCallback;

  Future<GlobalService> init({
    List<Locale>? supportedLocales,
    LocaleChangeCallback? localeChangeCallback,
  }) async {
    WidgetsBinding.instance.addObserver(this);
    eventBus = EventBus();
    await SpUtil.getInstance();
    this.localeChangeCallback = localeChangeCallback;
    //初始化本地语言配置
    _initLocale(supportedLocales);
    //初始化主题配置
    _initTheme();
    return this;
  }

  /// 设置语言变更回调
  void setLocaleChangeCallback(LocaleChangeCallback? localeChangeCallback) {
    this.localeChangeCallback = localeChangeCallback;
  }

  @override
  void onClose() {
    super.onClose();
    WidgetsBinding.instance.removeObserver(this);
  }

  /// 系统当前是否是暗黑模式
  bool isDarkModel(BuildContext context) {
    Brightness brightness = MediaQuery.of(context).platformBrightness;
    return brightness == Brightness.dark;
  }

  /// 初始 theme
  void _initTheme() {
    var themeCode = SpUtil.getString(themeCodeKey, defValue: 'system');
    switch (themeCode) {
      case 'system':
        _themeMode = ThemeMode.system;
        break;
      case 'light':
        _themeMode = ThemeMode.light;
        break;
      case 'dark':
        _themeMode = ThemeMode.dark;
        break;
    }
  }

  /// 更改主题
  Future<void> changeThemeMode(ThemeMode themeMode) async {
    _themeMode = themeMode;
    Get.changeThemeMode(_themeMode);
    if (_themeMode == ThemeMode.system) {
      await SpUtil.putString(themeCodeKey, 'system');
    } else {
      await SpUtil.putString(
          themeCodeKey, themeMode == ThemeMode.dark ? 'dark' : 'light');
    }
    updateNavigationBar();
    refreshAppUi();
  }

  updateNavigationBar([BuildContext? context]) {
    if (Platform.isAndroid) {
      bool isDarkMode = isDarkModel(context ?? Get.context!);
      if (_themeMode != ThemeMode.system) {
        isDarkMode = _themeMode == ThemeMode.dark;
      }
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          systemNavigationBarDividerColor: Colors.transparent,
          systemNavigationBarColor: isDarkMode ? Colors.black87 : Colors.white,
          systemNavigationBarIconBrightness: isDarkMode
              ? Brightness.light // Light icons on dark background
              : Brightness.dark,
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              isDarkMode ? Brightness.light : Brightness.dark,
          statusBarBrightness: isDarkMode ? Brightness.dark : Brightness.light,
          systemStatusBarContrastEnforced: isDarkMode,
        ),
      );
    }
  }

  /// 监听平台切换了主题模式
  @override
  void didChangePlatformBrightness() {
    super.didChangePlatformBrightness();
    if (_themeMode == ThemeMode.system) {
      refreshAppUi();
    }
  }

  /// 监听应用生命周期并发送给全部页面
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    sendEvent(LifecycleEvent(state));
  }

  // 初始化本地语言配置
  void _initLocale(List<Locale>? supportedLocales) {
    if (supportedLocales == null) {
      return;
    }
    var langCode = SpUtil.getString(languageCodeKey);
    if (langCode.isEmpty) {
      return;
    }
    var index = supportedLocales.indexWhere((element) {
      return element.languageCode == langCode;
    });
    if (index < 0) {
      return;
    }
    locale = supportedLocales[index];
    localeChangeCallback?.call(locale);
  }

  // 更改语言
  Future<void> changeLocale(Locale value) async {
    locale = value;
    localeChangeCallback?.call(locale);
    await SpUtil.putString(languageCodeKey, value.languageCode);
    Get.updateLocale(value);
    refreshAppUi();
  }

  // 获设备信息
  Future<BaseDeviceInfo> getDeviceInfo() async {
    _baseDeviceInfo ??= await DeviceInfoPlugin().deviceInfo;
    return _baseDeviceInfo!;
  }
}
