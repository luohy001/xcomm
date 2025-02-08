import 'dart:async';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'net_configs.dart';
enum HttpMethod {
  get,
  post,
  put,
  delete,
}

///网络封装
class NetUtil {
  factory NetUtil() => instance;

  static NetUtil? _instance;

  static NetUtil get instance => _instance ??= NetUtil._internal();

  Dio dio = Dio();
  final CancelToken _cancelToken = CancelToken();

  NetUtil._internal() {
    dio.options = BaseOptions(
      connectTimeout: NetConfig.connectTimeout,
      sendTimeout: NetConfig.sendTimeout,
      receiveTimeout: NetConfig.receiveTimeout,
      contentType: NetConfig.contentType,
      responseType: ResponseType.json,
    );
  }

  ///初始化公共属性
  ///
  /// [baseUrl] 地址前缀
  /// [connectTimeout] 连接超时赶时间
  /// [sendTimeout] 发送超时赶时间
  /// [receiveTimeout] 接收超时赶时间
  /// [interceptors] 基础拦截器
  /// [proxyEnable] 是否开启代理
  /// [proxyIp] 代理ip
  /// [proxyPort] 代理端口
  void init({
    required String baseUrl,
    Duration? connectTimeout,
    Duration? sendTimeout,
    Duration? receiveTimeout,
    List<Interceptor>? interceptors,
    bool ignoreCertificates = true,
  }) {
    //初始化默认参数
    dio.options.baseUrl = baseUrl;
    dio.options.connectTimeout = connectTimeout ?? NetConfig.connectTimeout;
    dio.options.sendTimeout = sendTimeout ?? NetConfig.sendTimeout;
    dio.options.receiveTimeout = receiveTimeout ?? NetConfig.receiveTimeout;
    if (ignoreCertificates) {
      dio.httpClientAdapter = IOHttpClientAdapter(
        createHttpClient: () {
          final HttpClient client =
              HttpClient(context: SecurityContext(withTrustedRoots: false));
          client.badCertificateCallback = (cert, host, port) => true;
          return client;
        },
      );
    }
    //添加拦截器
    if (interceptors != null && interceptors.isNotEmpty) {
      dio.interceptors.addAll(interceptors);
    }
  }

  /// Request 操作
  Future<T> request<T>(
    String path, {
    required HttpMethod method,
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    //处理网络类型
    if (method == HttpMethod.get) {
      dio.options.method = 'GET';
    } else if (method == HttpMethod.post) {
      dio.options.method = 'POST';
    } else if (method == HttpMethod.delete) {
      dio.options.method = 'DELETE';
    } else if (method == HttpMethod.put) {
      dio.options.method = 'PUT';
    }
    //处理请求设置
    options = options ?? Options();
    Completer<T> completer = Completer();
    dio
        .request<T>(
          path,
          data: data,
          queryParameters: queryParameters,
          options: options,
          cancelToken: cancelToken ?? _cancelToken,
          onSendProgress: onSendProgress,
          onReceiveProgress: onReceiveProgress,
        )
        .then((value) => {
              completer.complete(value.data),
            })
        .catchError((error) => {
              completer.complete(null),
            })
        .whenComplete(() => null);

    return completer.future;
  }

  /// 添加拦截器
  void addInterceptor(Interceptor interceptor) {
    //一种类型的拦截器只能添加一次
    for (var item in dio.interceptors) {
      if (item.runtimeType == interceptor.runtimeType) {
        return;
      }
    }

    dio.interceptors.add(interceptor);
  }

  /// 移除拦截器
  void removeIntercept(Interceptor interceptor) {
    dio.interceptors.remove(interceptor);
  }

  /// 取消请求
  ///
  /// 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
  /// 所以参数可选
  void cancelRequests({CancelToken? token}) {
    token ?? _cancelToken.cancel("cancelled");
  }
}
