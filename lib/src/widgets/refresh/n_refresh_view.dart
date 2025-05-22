import 'package:easy_refresh/easy_refresh.dart';
import 'package:flutter/material.dart';

typedef ValueIndexedWidgetBuilder<T> = Widget Function(
    BuildContext context, int index, T data);

/// 请求列表回调
typedef RequestListCallback<T> = Future<List<T>> Function(
    bool isRefresh, int pageNo, int pageSize, T? last,);


/// 刷新列表
/// 刷新列表组件化
class NRefreshView<T> extends StatefulWidget {
  const NRefreshView({
    super.key,
    this.controller,
    this.child,
    this.placeholder,
    required this.onRequest,
    this.pageSize = 20,
    this.pageNoInitial = 1,
    this.disableOnReresh = false,
    this.disableOnLoad = false,
    this.needRemovePadding = false,
    required this.itemBuilder,
    this.separatorBuilder,
    this.cachedChild,
    this.refreshController,
    this.tag,
  });
  /// 控制器
  final NRefreshViewController<T>? controller;

  /// 子视图(为空 默认 带刷新组件的 ListView)
  final Widget? child;

  /// 刷新页面不变的部分,
  final Widget? cachedChild;

  final Widget? placeholder;

  /// 每页数量
  final int pageSize;

  /// 页面初始索引
  final int pageNoInitial;

  /// 禁用下拉刷新
  final bool disableOnReresh;

  /// 禁用上拉加载
  final bool disableOnLoad;

  /// 使用使用 MediaQuery.removePadding
  final bool needRemovePadding;

  /// 请求方法
  final RequestListCallback<T> onRequest;

  /// ListView 的 itemBuilder
  final ValueIndexedWidgetBuilder<T> itemBuilder;

  /// ListView 的 separatorBuilder
  final IndexedWidgetBuilder? separatorBuilder;

  /// 刷新控制器
  final EasyRefreshController? refreshController;

  final String? tag;

  @override
  NRefreshViewState<T> createState() => NRefreshViewState<T>();
}

class NRefreshViewState<T> extends State<NRefreshView<T>> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  late final _easyRefreshController = widget.refreshController ??
      EasyRefreshController(
        controlFinishRefresh: true,
        controlFinishLoad: true,
      );

  final _scrollController = ScrollController();

  var indicator = IndicatorResult.none;

  late var pageNo = widget.pageNoInitial;

  late final items = ValueNotifier(<T>[]);

  /// 首次加载
  var isFirstLoad = true;

  @override
  void dispose() {
    widget.controller?._detach(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    widget.controller?._attach(this);

    widget.onRequest(true, pageNo, widget.pageSize, null).then((value) {
      items.value = value;
      isFirstLoad = false;

      if (mounted) {
        setState(() {});
      }
    });
  }

  @override
  void didUpdateWidget(covariant NRefreshView<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.controller != oldWidget.controller ||
        widget.placeholder != oldWidget.placeholder ||
        widget.onRequest != oldWidget.onRequest ||
        widget.itemBuilder != oldWidget.itemBuilder ||
        widget.separatorBuilder != oldWidget.separatorBuilder ||
        widget.cachedChild != oldWidget.cachedChild ||
        widget.tag != widget.tag
    ) {
      onRefresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if (isFirstLoad) {
      //return const NSkeletonScreen();
    }

    return buildBody();
  }

  buildBody() {
    return ValueListenableBuilder<List<T>>(
      valueListenable: items,
      builder: (context, list, child) {

        if (list.isEmpty) {
          /*return widget.placeholder ?? NPlaceholder(
            onTap: onRefresh,
          );*/
        }

        return buildRefresh(
          child: widget.child ??
              buildListView(
                controller: _scrollController,
                needRemovePadding: widget.needRemovePadding,
                items: list,
              ),
        );
      },
    );
  }

  Widget buildRefresh({
    Widget? child,
  }) {
    return EasyRefresh(
      controller: _easyRefreshController,
      triggerAxis: Axis.vertical,
      onRefresh: widget.disableOnReresh ? null : () => onRefresh(),
      onLoad: widget.disableOnLoad || indicator == IndicatorResult.noMore
          ? null
          : () => onLoad(),
      child: child,
    );
  }

  onRefresh() async {
    pageNo = widget.pageNoInitial;
    items.value = await widget.onRequest(true, pageNo, widget.pageSize, null);
    indicator = items.value.length < widget.pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    _easyRefreshController.finishRefresh(indicator);
  }

  onLoad() async {
    if (!mounted) {
      return;
    }
    if (indicator == IndicatorResult.noMore) {
      return;
    }

    pageNo += 1;

    final models = await widget.onRequest(
        false,
        pageNo,
        widget.pageSize,
        items.value.isNotEmpty ? items.value.last : null);
    items.value = [...items.value, ...models];

    indicator = models.length < widget.pageSize
        ? IndicatorResult.noMore
        : IndicatorResult.success;
    _easyRefreshController.finishLoad(indicator);
  }

  Widget buildListView({
    ScrollController? controller,
    bool needRemovePadding = false,
    required List<T> items,
  }) {
    Widget child = Scrollbar(
      controller: controller,
      child: ListView.separated(
        controller: controller,
        itemCount: items.length,
        itemBuilder: (context, index) =>
            widget.itemBuilder(context, index, items[index],),
        separatorBuilder: widget.separatorBuilder ??
                (context, index) {
              return const Divider(
                color: Color(0xffe4e4e4),
                height: 1,
              );
            },
      ),
    );
    if (needRemovePadding) {
      child = MediaQuery.removePadding(
        removeTop: true,
        removeBottom: true,
        context: context,
        child: child,
      );
    }
    return child;
  }
}

/// NRefreshView 组件控制器,将 NRefreshViewState 的私有属性或者方法暴漏出去
class NRefreshViewController<E> {

  NRefreshViewState<E>? _anchor;

  List<E> get items {
    assert(_anchor != null);
    return _anchor!.items.value;
  }

  void onRefresh() {
    assert(_anchor != null);
    _anchor!.onRefresh();
  }


  void _attach(NRefreshViewState<E> anchor) {
    _anchor = anchor;
  }

  void _detach(NRefreshViewState<E> anchor) {
    if (_anchor == anchor) {
      _anchor = null;
    }
  }
}
/*buildBody() {
  return NRefreshView<DepartmentPageDetailModel>(
    pageSize: 2,
    onRequest: (bool isRefresh, int page, int pageSize, last) async {

      return await requestList(pageNo: page, pageSize: pageSize);
    },
    itemBuilder: (BuildContext context, int index, e, onRefresh) {

      return InkWell(
        onTap: () {
          YLog.d("${e.toJson()}");
        },
        child: PatientSchemeCell(
          model: e,
          index: index,
        ),
      );
    },
  );
}*/

/// 列表数据请求
/*Future<List<DepartmentPageDetailModel>> requestList({
  required int pageNo,
  int pageSize = 20,
}) async {
  var api = SchemePageApi(
    ownerId: arguments['userId'] ?? '',
    pageNo: pageNo,
    pageSize: pageSize,
  );

  Map<String, dynamic>? response = await api.startRequest();
  if (response['code'] != 'OK') {
    return [];
  }

  final rootModel = DepartmentPageRootModel.fromJson(response ?? {});
  var list = rootModel.result?.content ?? [];
  return list;
}*/
