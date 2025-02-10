import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';
import 'package:xcomm/xcomm.dart';

/// 刷新配置
class PullRefreshController extends StatelessWidget {
  const PullRefreshController({
    super.key,
    required this.pagingMixin,
    required this.childBuilder,
    this.header,
    this.footer,
    this.locatorMode = false,
    this.refreshOnStart = true,
    this.startRefreshHeader,
  });

  final Header? header;
  final Footer? footer;

  final bool refreshOnStart;
  final Header? startRefreshHeader;

  /// 列表视图
  final ERChildBuilder childBuilder;

  /// 分页控制器
  final PagingMixin pagingMixin;

  /// 是否固定刷新偏移
  final bool locatorMode;

  @override
  Widget build(BuildContext context) {
    final firstRefreshHeader = startRefreshHeader ??
        BuilderHeader(
          triggerOffset: 70,
          clamping: true,
          position: IndicatorPosition.above,
          processedDuration: Duration.zero,
          builder: (ctx, state) {
            if (state.mode == IndicatorMode.inactive ||
                state.mode == IndicatorMode.done) {
              return const SizedBox();
            }
            return Container(
              padding: const EdgeInsets.only(bottom: 100),
              width: double.infinity,
              height: state.viewportDimension,
              alignment: Alignment.center,
              child: SpinKitFadingCube(
                size: 25,
                color: Theme.of(context).primaryColor,
              ),
            );
          },
        );

    return EasyRefresh.builder(
      controller: pagingMixin.pagingController,
      header: header ??
          MaterialHeader(
            clamping: locatorMode,
            position: locatorMode
                ? IndicatorPosition.locator
                : IndicatorPosition.above,
          ),
      footer: footer ??
          CupertinoFooter(
            emptyWidget: Text(
              'No more data',
              style: TextStyle(
                color: ThemeColor.secondary,
                fontSize: 12.sp,
              ),
            ),
          ),
      refreshOnStart: refreshOnStart,
      resetAfterRefresh: false,
      refreshOnStartHeader: firstRefreshHeader,
      onRefresh: pagingMixin.onRefresh,
      onLoad: pagingMixin.onLoad,
      childBuilder: (context, physics) {
        return ValueListenableBuilder(
          valueListenable: pagingMixin.state,
          builder: (context, value, child) {
            if (value.isStartEmpty) {
              return const EmptyWidget();
            }
            return childBuilder.call(context, physics);
          },
        );
      },
    );
  }
}
