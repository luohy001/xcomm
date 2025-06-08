import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xcomm/src/controller/index.dart';

import 'status/status.dart';

class ComLayoutContainer extends StatelessWidget {
  final ComLayoutController refreshContainerController;
  final Widget child;
  final Widget? skeleton;

  const ComLayoutContainer({
    required this.refreshContainerController,
    required this.child,
    this.skeleton,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return refreshContainerController.obx(
      (_) => buildRefreshWidget(),
      onLoading: skeleton ?? LoadingStatusWidget(),
      onError: (err) => ErrorStatusWidget(),
    );
  }

  buildRefreshWidget() {
    return EasyRefresh(
      header: const MaterialHeader(backgroundColor: Colors.white),
      footer: null,
      controller: refreshContainerController.easyRefreshController,
      onLoad: null,
      onRefresh: refreshContainerController.onRefresh,
      child: child,
    );
  }
}
