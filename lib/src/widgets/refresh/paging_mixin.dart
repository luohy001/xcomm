import 'dart:async';

import 'package:easy_refresh/easy_refresh.dart';
import 'state.dart';

mixin PagingMixin<T> {
  /// 刷新控制器
  final EasyRefreshController _pagingController = EasyRefreshController(
    controlFinishLoad: true,
    controlFinishRefresh: true,
  );

  EasyRefreshController get pagingController => _pagingController;

  /// 初始页码
  int _initPage = 1;
  final int _pageSize = 20;

  /// 当前页码
  int _page = 1;

  int get page => _page;

  int get pageSize => _pageSize;

  /// 列表数据
  List<T> get items => _state.items;

  int get itemCount => items.length;

  /// 错误信息
  dynamic get error => _state.error;

  /// 关联刷新状态管理的控制器
  PagingMixinController get state => _state;
  final PagingMixinController<T> _state = PagingMixinController(
    PagingMixinData(items: []),
  );

  /// 是否加载更多
  bool _isLoadMore = true;

  bool get isLoadMore => _isLoadMore;

  /// 控制刷新结束回调（异步处理）
  Completer? _refreshCompleter;

  /// 挂载分页器
  /// `controller` 关联刷新状态管理的控制器
  /// `initPage` 初始页码值(分页起始页)
  /// `isLoadMore` 是否加载更多
  void initPaging({
    int initPage = 1,
    isLoadMore = true,
  }) {
    _isLoadMore = isLoadMore;
    _initPage = initPage;
    _page = initPage;
  }

  /// 获取数据
  Future fetchData(int page, int pageSize);

  /// 刷新数据
  Future onRefresh() async {
    _refreshCompleter = Completer();
    _page = _initPage;
    fetchData(_page, _pageSize);
    return _refreshCompleter!.future;
  }

  /// 加载更多数据
  Future onLoad() async {
    _refreshCompleter = Completer();
    _page++;
    fetchData(_page, _pageSize);
    return _refreshCompleter!.future;
  }

  /// 获取数据后调用
  /// `items` 列表数据
  /// `maxCount` 数据总数，如果为0则默认通过 `items` 有无数据判断是否可以分页加载, null为非分页请求
  /// `error` 错误信息
  /// `limit` 单页显示数量限制，如果items.length < limit 则没有更多数据
  void endLoad(
    List<T>? list, {
    int? maxCount,
    dynamic error,
  }) {
    if (_page == _initPage) {
      _refreshCompleter?.complete();
      _refreshCompleter = null;
    }
    final dataList = List.of(_state.value.items);
    if (list != null) {
      if (_page == _initPage) {
        dataList.clear();
        // 更新数据
        _pagingController.finishRefresh();
        _pagingController.resetFooter();
      }
      dataList.addAll(list);
      // 更新列表
      _state.value = _state.value.copyWith(
        items: dataList,
        isStartEmpty: page == _initPage && list.isEmpty,
      );
      bool isNoMore = true;
      if (maxCount != null) {
        isNoMore = itemCount >= maxCount;
      }
      var state = IndicatorResult.success;
      if (isNoMore) {
        state = IndicatorResult.noMore;
      }
      _pagingController.finishLoad(state);
    } else {
      if (_page == _initPage) {
        _pagingController.finishRefresh();
        _pagingController.resetFooter();
      } else {
        _pagingController.finishLoad(IndicatorResult.noMore);
      }
      _state.value = _state.value.copyWith(
        items: [],
        isStartEmpty: true,
        error: error ?? 'Data request error',
      );
    }
  }

  /// 外部更新更新数据
  void updateItems(List<T> list) {
    // 更新列表
    _state.value = _state.value.copyWith(items: list);
  }

  /// 如果本地需要修改列表信息
  /// 可以参考这里: [updateItems]
  void insertItems() {
    // 更新列表
    final dataList = List.of(items);
    dataList.insert(0, items.first);
    _state.value = _state.value.copyWith(items: dataList);
  }
}
