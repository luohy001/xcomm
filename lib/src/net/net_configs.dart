import 'package:dio/dio.dart';
class NetConfig {
  /// 禁用实例化HttpConfig类
  NetConfig._();


  /// 超时时间 20s
  static const Duration connectTimeout = Duration(seconds: 20);

  /// 发送超时时间 20s
  static const Duration sendTimeout = Duration(seconds: 20);

  /// 接收超时时间 20s
  static const Duration receiveTimeout = Duration(seconds: 20);

  /// 请求内容json form，UTF-8
  static const String contentType = Headers.jsonContentType;
  static const String headerContentType = "content-type";
}
