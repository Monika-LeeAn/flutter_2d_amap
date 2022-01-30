import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_multiple_annotation_controller.dart';

class AMap2DMobileMultipleAnnotationController
    extends AMap2DMultipleAnnotationController {
  AMap2DMobileMultipleAnnotationController.customInit(
    int id,
    // this._widget,
  ) : _channel = MethodChannel(
            'plugins.zhangyu/flutter_2d_multiple_annotation_$id') {
    print('给客户端通知Flutter设置了一个channel,初始化的时候会打印折行数据');
  }

  final MethodChannel _channel;

  // final AMap2DView _widget;

  @override
  Future<void> move(String lat, String lon) async {
    return _channel
        .invokeMethod('move', <String, dynamic>{'lat': lat, 'lon': lon});
  }

  @override
  Future<void> location() async {
    return _channel.invokeMethod('location');
  }
}
