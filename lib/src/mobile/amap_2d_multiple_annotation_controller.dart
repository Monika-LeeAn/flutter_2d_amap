import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/src/amap_2d_multiple_annotation_view.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_multiple_annotation_controller.dart';

class AMap2DMobileMultipleAnnotationController
    extends AMap2DMultipleAnnotationController {
  AMap2DMobileMultipleAnnotationController.customInit(
    int id,
    this._widget,
  ) : _channel = MethodChannel(
            'plugins.zhangyu/flutter_2d_multiple_annotation_$id') {
    print('给客户端通知Flutter设置了一个channel,初始化的时候会打印折行数据');
    _channel.setMethodCallHandler(_handleMethod);
  }

  final MethodChannel _channel;

  final AMap2DMultipleAnnotationView _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    final String method = call.method;
    switch (method) {
      case 'didClickedAnnation':
        {
          print('Flutter收到用户在iOS端点击某个标注的方法');
          if (_widget.didClickAnnotationCallBack != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print(args);
            _widget.didClickAnnotationCallBack!(this, args);
          }
        }
        break;
      case 'ratioChanged':
        {
          print('flutter 收到 iOS端发送的消息--ratioChanged');
          if (_widget.onAmap2DViewRatioChanged != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print(args);
            print('iOS视图创建完成5, widget.onAmap2DViewRatioChanged!(controller)');
            _widget.onAmap2DViewRatioChanged!(this, args);
          }
        }
        break;

      case 'didSingleTappedAtCoordinate':
        {
          print('flutter 收到 iOS端发送的消息--didSingleTappedAtCoordinate');
          if (_widget.onAmap2DViewRatioChanged != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print(args);
            print('iOS视图创建完成5, widget.onAmap2DViewRatioChanged!(controller)');
            _widget.onAmap2DViewRatioChanged!(this, args);
          }
        }
        break;
      // case 'poiSearchResult':
      //   {
      //     if (_widget.onPoiSearched != null) {
      //       final Map args = call.arguments as Map<dynamic, dynamic>;
      //       final List<PoiSearch> list = [];
      //       (json.decode(args['poiSearchResult'] as String) as List).forEach((dynamic value) {
      //         list.add(PoiSearch.fromJsonMap(value as Map<String, dynamic>));
      //       });
      //       _widget.onPoiSearched!(list);
      //     }
      //     return Future<dynamic>.value('');
      //   }
    }
    return Future<dynamic>.value('');
  }

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

  @override
  Future<void> setAnnomations(List entities, String level) async {
    return _channel.invokeMethod('setAnnomations',
        <String, dynamic>{'entities': entities, 'customMapLevel': level});
  }
}
