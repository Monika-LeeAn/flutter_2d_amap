import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_2d_amap/src/mobile/amap_2d_multiple_annotation_controller.dart';

import '../amap_2d_multiple_annotation_view.dart';

class AMap2DMobileMultipleAnnotationState
    extends State<AMap2DMultipleAnnotationView> {
  ///Completer已经说明一切了
  final Completer<AMap2DMobileMultipleAnnotationController> _controller =
      Completer<AMap2DMobileMultipleAnnotationController>();

  /////Callback to invoke after the platform view has been created.
  void _onPlatformViewCreated(int id) {
    print('iOS视图创建完成1, 准备controller');
    final AMap2DMobileMultipleAnnotationController controller =
        AMap2DMobileMultipleAnnotationController.customInit(id, widget);

    ///  注释1:
    ///  void complete([FutureOr<T>? value]);
    ///  参数就是future的返回值
    print('iOS视图创建完成2, 给Completer调用complete,确定future的返回值');
    _controller.complete(controller);

    /// 注释2:
    /// 自定义的一个方法,如果有这个函数,就调用这个函数
    print('iOS视图创建完成3, widget.onAMap2DViewCreated != null');
    if (widget.onAMap2DViewCreated != null) {
      print('iOS视图创建完成4, widget.onAMap2DViewCreated!(controller)');
      widget.onAMap2DViewCreated!(controller);
    }

    // if (widget.onAmap2DViewRatioChanged != null) {
    //   print('iOS视图创建完成5, widget.onAmap2DViewRatioChanged!(controller)');
    //   widget.onAmap2DViewRatioChanged!(controller);
    // }
  }

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'plugins.weilu/flutter_2d_amap',
        onPlatformViewCreated: _onPlatformViewCreated,
        creationParams: _CreationParams.fromWidget(widget).toMap(),
        creationParamsCodec: const StandardMessageCodec(),
      );
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return UiKitView(
        viewType:
            'plugins.zhangyu/flutter_2d_multiple_annotation_uiview', //字符串类型 唯一标识符
        onPlatformViewCreated: _onPlatformViewCreated,

        ///Callback to invoke after the platform view has been created.
        creationParams: _CreationParams.fromWidget(widget).toMap(),

        /// 这可以被插件用来向嵌入式iOS视图传递构造参数。
        creationParamsCodec: const StandardMessageCodec(),
      );
    }
    return Text(
        '$defaultTargetPlatform is not yet supported by the flutter_2d_amap plugin');
  }
}

/// 需要更多的初始化配置，可以在此处添加
class _CreationParams {
  ///初始化方法
  _CreationParams();

  ///静态初始化方法
  static _CreationParams fromWidget(AMap2DMultipleAnnotationView widget) {
    return _CreationParams();
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{};
  }
}
