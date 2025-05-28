import 'dart:io';

import 'package:dio/dio.dart';

class NetException {
  static NetError handle(
    DioException error, {
    String code = 'code',
    String message = 'message',
  }) {
    if (error.error is SocketException) {
      return NetError('F10005', "Network connection error");
    }
    switch (error.type) {
      case DioExceptionType.cancel:
        return NetError('CS0001', "Request cancellation");
      case DioExceptionType.connectionTimeout:
        return NetError('CS0002', "Connection timeout");
      case DioExceptionType.sendTimeout:
        return NetError('CS0003', "Request timeout");
      case DioExceptionType.receiveTimeout:
        return NetError('CS0004', "Response timeout");
      case DioExceptionType.connectionError:
        return NetError('CS0005', "Network connection error");
      case DioExceptionType.badResponse:
        try {
          var responseData = error.response?.data;
          if (responseData is Map<String, dynamic>) {
            return NetError(
              (responseData[code] ?? 'CS0006').toString(),
              responseData[message] ?? 'unknown error',
            );
          }
          int errCode = error.response?.statusCode ?? -1;
          switch (errCode) {
            case 400:
              return NetError('CS1400', "Request syntax error");
            case 401:
              return NetError('CS1401', 'invalid token');
            case 403:
              return NetError('CS1403', "Server refused execution");
            case 404:
              return NetError('CS1403', "Unable to connect to server");
            case 405:
              return NetError(
                  'CS1404'.toString(), "Request method is disabled");
            case 500:
              return NetError('CS1500', "Server internal error");
            case 502:
              return NetError('CS1502', "Invalid request");
            case 503:
              return NetError('CS1503'.toString(), "The server is down.");
            case 505:
              return NetError('CS1505', "http requests are not supported");
            default:
              return NetError('CS1$errCode',
                  error.response?.statusMessage ?? 'unknown error');
          }
        } catch (e) {
          return NetError('CS0000', "unknown error：${e.toString()}");
        }
      default:
        return NetError('CS0000', error.message ?? 'system error');
    }
  }
}

class NetError {
  final String message;
  final String code;

  NetError(this.code, this.message);
}
