import 'package:flutter/services.dart';
import 'package:flutter_2d_amap/src/amap_2d_limit_view.dart';
import 'package:flutter_2d_amap/src/amap_2d_multiple_annotation_view.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_limit_controller.dart';

class AMapMobile2DLimitController extends AMap2DLimitController {
  AMapMobile2DLimitController.customInit(
    int id,
    this._widget,
  ) : _channel = MethodChannel('plugins.zhangyu/flutter_2d_limit_$id') {
    print('给客户端通知Flutter设置了一个channel,初始化的时候会打印折行数据');
    _channel.setMethodCallHandler(_handleMethod);
  }

  final MethodChannel _channel;

  final AMap2DLimitView _widget;

  Future<dynamic> _handleMethod(MethodCall call) async {
    final String method = call.method;
    switch (method) {
      case 'regionsCallBack':
        {
          // print('Flutter收到用户在iOS端点击某个标注的方法');
          // if (_widget.didClickAnnotationCallBack != null) {

          if (_widget.onAmap2DLimitRegionStatusChanged != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print('状态改变的回调');
            print(args);
            _widget.onAmap2DLimitRegionStatusChanged!(this, args);
          }
          //   _widget.didClickAnnotationCallBack!(this, args);
          // }
        }
        break;

      case 'didUpdateLocation':
        {
          print('flutter 收到 iOS端发送的消息--ratioChanged');
          if (_widget.onAMap2DViewCreated != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print(args);
            print(
                'iOS视图创建完成-第一次获取位置, widget.onAmap2DViewRatioChanged!(controller)');
            _widget.onAMap2DViewCreated!(this, args);
          }
        }
        break;
      // }

      case 'noty_didUpdateLocation':
        {
          print('flutter 收到 iOS端发送的消息--noty_didUpdateLocation');
          if (_widget.onAmap2DLimitLocationUpdateChanged != null) {
            final Map args = call.arguments as Map<dynamic, dynamic>;
            print(args);
            print('onAmap2DLimitLocationUpdateChanged!(controller)');
            _widget.onAmap2DLimitLocationUpdateChanged!(this, args);
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

  @override
  Future<void> getRegionsStatus() {
    // TODO: implement getRegionsStatus
    return _channel.invokeMethod('getRegionsStatus');
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

  @override
  Future<void> setCompany(
      String lat, String lon, String lat2, String lon2) async {
    return _channel.invokeMethod('setCompany',
        <String, dynamic>{'lat': lat, 'lon': lon, 'lat2': lat2, 'lon2': lon2});
  }
}
