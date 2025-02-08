import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:lottie/lottie.dart';
import 'package:xcomm/xcomm.dart';

/// 加载状态
enum LoadStatus {
  loading,
  error,
  empty,
  complete,
}

/// 加载控制器
class LoadController extends ChangeNotifier {
  LoadStatus status = LoadStatus.loading;

  void loading() {
    status = LoadStatus.loading;
    notifyListeners();
  }

  void error() {
    status = LoadStatus.error;
    notifyListeners();
  }

  void empty() {
    status = LoadStatus.empty;
    notifyListeners();
  }

  void complete() {
    status = LoadStatus.complete;
    notifyListeners();
  }
}

class LoadContainer extends StatefulWidget {
  final LoadController controller;
  final Widget child;
  final Widget? loadingWidget;
  final String? loadingMessage;
  final Widget? errorWidget;
  final String? errorMessage;
  final Widget? emptyWidget;
  final String? emptyMessage;
  final Function? onReLoad;

  const LoadContainer({
    super.key,
    required this.controller,
    required this.child,
    this.loadingWidget,
    this.loadingMessage,
    this.errorWidget,
    this.errorMessage,
    this.emptyWidget,
    this.emptyMessage,
    this.onReLoad,
  });

  @override
  State<LoadContainer> createState() => _LoadingContainerState();
}

class _LoadingContainerState extends State<LoadContainer>
    with TickerProviderStateMixin {
  late AnimationController _loadingAnimationController;
  late Animation<double> _loadingAnimation;
  late AnimationController _childAnimationController;
  late Animation<double> _childAnimation;

  @override
  void initState() {
    super.initState();
    _loadingAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
      value: widget.controller.status == LoadStatus.loading ? 1.0 : 0.0,
    );
    _loadingAnimation = _loadingAnimationController.view;
    _childAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
      value: widget.controller.status == LoadStatus.loading ? 0.0 : 1.0,
    );
    _childAnimation = _childAnimationController.view;
    widget.controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    setState(() {
      _loadingAnimationController.animateTo(
          widget.controller.status == LoadStatus.loading ? 1.0 : 0.0);
      _childAnimationController.animateTo(
          widget.controller.status == LoadStatus.loading ? 0.0 : 1.0);
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _loadingAnimationController.dispose();
    _childAnimationController.dispose();
    super.dispose();
  }

  Widget _buildLoadingWidget() {
    return Center(
      child: SpinKitRipple(
        color: ThemeColor.primaryContainer,
        size: 60.sp,
      ),
    );
  }

  Widget _buildErrorWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Lottie.asset(
          'assets/lottie/error.json',
          width: 0.6.sw,
          height: 0.6.sw,
        ),
        TextX.labelMedium(widget.emptyMessage ?? '网络错误,点击重试'),
      ],
    );
  }

  Widget _buildEmptyWidget() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Lottie.asset(
          'assets/lottie/error.json',
          width: 0.6.sw,
          height: 0.6.sw,
        ),
        TextX.labelMedium(widget.emptyMessage ?? '暂无数据,点击重试'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget? ws;
    switch (widget.controller.status) {
      case LoadStatus.error:
        ws = GestureDetector(
          onTap: () {
            if (widget.onReLoad != null) {
              widget.onReLoad!();
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.errorWidget ?? _buildErrorWidget(),
          ),
        );
        break;
      case LoadStatus.empty:
        ws = GestureDetector(
          onTap: () {
            if (widget.onReLoad != null) {
              widget.onReLoad!();
            }
          },
          child: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: widget.emptyWidget ?? _buildEmptyWidget(),
          ),
        );
        break;
      case LoadStatus.complete:
        ws = widget.child;
        break;
      default:
        break;
    }
    return Stack(children: [
      if (ws != null)
        FadeTransition(
          opacity: _childAnimation,
          child: ws,
        ),
      FadeTransition(
        opacity: _loadingAnimation,
        child: _buildLoadingWidget(),
      ),
    ]);
  }
}
