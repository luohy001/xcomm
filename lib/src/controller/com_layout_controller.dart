import 'package:easy_refresh/easy_refresh.dart';
import 'package:get/get.dart';

class ComLayoutController extends GetxController with StateMixin {
  final EasyRefreshController easyRefreshController = EasyRefreshController();

  @override
  void onInit() {
    pageInit();
    super.onInit();
  }

  @override
  onClose() {
    easyRefreshController.dispose();
  }

  Future onRefresh() async {
    await loadData();
  }

  Future pageInit() async {
    try {
      change(null, status: RxStatus.loading());
      var result = await loadData();
      if (result == null) {
        change(null, status: RxStatus.error());
        return;
      }
      change(result, status: RxStatus.success());
    } catch (e) {
      change(null, status: RxStatus.error());
    }
  }

  Future loadData() async {
    return null;
  }
}
