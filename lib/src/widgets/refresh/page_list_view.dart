import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:xcomm/src/controller/index.dart';

import '../status/status.dart';

typedef IndexedWidgetBuilder = Widget Function(BuildContext context, int index);

class PageListView extends StatelessWidget {
  final BasePageController pageController;
  final IndexedWidgetBuilder itemBuilder;
  final IndexedWidgetBuilder? separatorBuilder;
  final EdgeInsets? padding;
  final bool firstRefresh;
  final Function()? onLoginSuccess;
  final bool showPageLoading;
  const PageListView({
    required this.itemBuilder,
    required this.pageController,
    this.padding,
    this.firstRefresh = false,
    this.showPageLoading = false,
    this.separatorBuilder,
    this.onLoginSuccess,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => Stack(
        children: [
          EasyRefresh(
            header: const MaterialHeader(),
            footer: const MaterialFooter(
              infiniteOffset: 100,
              clamping: false,
            ),
            controller: pageController.easyRefreshController,
            refreshOnStart: firstRefresh,
            onLoad: pageController.loadData,
            onRefresh: pageController.refreshData,
            child: ListView.separated(
              padding: padding,
              itemCount: pageController.list.length,
              itemBuilder: itemBuilder,
              controller: pageController.scrollController,
              separatorBuilder:
              separatorBuilder ?? (context, i) => const SizedBox(),
            ),
          ),
          Offstage(
            offstage: !pageController.pageEmpty.value,
            child: EmptyStatusWidget(
              onRefresh: () => pageController.refreshData(),
            ),
          ),
          Offstage(
            offstage: !(showPageLoading && pageController.pageLoading.value),
            child: const LoadingStatusWidget(),
          ),
          Offstage(
            offstage: !pageController.pageError.value,
            child: ErrorStatusWidget(
              errorMsg: pageController.errorMsg.value,
              onRefresh: () => pageController.refreshData(),
            ),
          ),
        ],
      ),
    );
  }
}