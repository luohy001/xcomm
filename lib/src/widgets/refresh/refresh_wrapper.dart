import 'package:flutter/material.dart';
import 'package:easy_refresh/easy_refresh.dart';
import '../status/status.dart';

class RefreshWrapper extends StatefulWidget {
  final Future Function() onRequest;
  final Widget child;
  final Widget? placeholder;
  final bool initializedData;
  final RefreshWrapperController? controller;

  const RefreshWrapper({
    super.key,
    required this.onRequest,
    required this.child,
    this.controller,
    this.placeholder,
    this.initializedData = false,
  });

  @override
  State<RefreshWrapper> createState() => RefreshWrapperState();
}

class RefreshWrapperState extends State<RefreshWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final EasyRefreshController easyRefreshController = EasyRefreshController(
    controlFinishRefresh: true,
  );
  //0-失败  1-加载中  2-成功
  late final status = ValueNotifier(1);

  @override
  void initState() {
    super.initState();
    widget.controller?.attach(this);
    if (widget.initializedData) {
      status.value = 2;
      return;
    }
    initData();
  }

  @override
  void didUpdateWidget(covariant RefreshWrapper oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.onRequest != oldWidget.onRequest) {
      widget.controller?.attach(this);
      onRefresh();
    }
  }

  onRefresh() async {
    var res = await widget.onRequest();
    status.value = res == null ? 0 : 2;
    easyRefreshController.finishRefresh(IndicatorResult.success);
  }

  Future<void> initData() async {
    await onRefresh();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return ValueListenableBuilder(
      valueListenable: status,
      builder: (context, st, child) {
        if (st == 1) {
          return widget.placeholder ?? LoadingStatusWidget();
        }
        if (st == 0) {
          return ErrorStatusWidget(onRefresh: onRefresh);
        }
        return buildRefresh(
          child: widget.child,
        );
      },
    );
  }

  Widget buildRefresh({
    Widget? child,
  }) {
    return EasyRefresh(
      controller: easyRefreshController,
      triggerAxis: Axis.vertical,
      header: MaterialHeader(
        backgroundColor: Colors.white.withValues(alpha: 0.9),
      ),
      onRefresh: () => onRefresh(),
      onLoad: null,
      child: child,
    );
  }

  @override
  void dispose() {
    easyRefreshController.dispose();
    widget.controller?.detach(this);
    super.dispose();
  }
}

class RefreshWrapperController {
  RefreshWrapperState? _anchor;

  void attach(RefreshWrapperState anchor) {
    _anchor = anchor;
  }

  void detach(RefreshWrapperState anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }

  void onRefresh() {
    assert(_anchor != null);
    _anchor!.onRefresh();
  }
}
