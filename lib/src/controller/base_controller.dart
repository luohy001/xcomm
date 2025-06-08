import '../../xcomm.dart';

class BaseController extends GetxController {
  /// 加载中，更新页面
  var pageLoading = false.obs;

  /// 加载中,不会更新页面
  var loading = false;

  /// 空白页面
  var pageEmpty = false.obs;

  /// 页面错误
  var pageError = false.obs;


  /// 错误信息
  var errorMsg = "".obs;

  /// 显示错误
  /// * [msg] 错误信息
  /// * [showPageError] 显示页面错误
  /// * 只在第一页加载错误时showPageError=true，后续页加载错误时使用Toast弹出通知
  void handleError(Object exception, {bool showPageError = false}) {
    DLog.d(exception);
    var msg = exceptionToString(exception);
    if (exception is NetError && exception.code == 'CS1401') {
      pageError.value = false;
      return;
    }
    if (showPageError) {
      pageError.value = true;
      errorMsg.value = msg;
    } else {
      SmartDialog.showToast(exceptionToString(msg));
    }
  }

  String exceptionToString(Object exception) {
    if (exception is NetError) {
      return exception.message;
    }
    return exception.toString().replaceAll("Exception:", "");
  }
}



