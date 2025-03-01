import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

export 'src/amap_2d_view.dart';
export 'src/interface/amap_2d_controller.dart';
export 'src/model/poi_search_model.dart';

export 'src/amap_2d_multiple_annotation_view.dart';
export 'src/interface/amap_2d_multiple_annotation_controller.dart';

export 'src/amap_2d_limit_view.dart';
export 'src/interface/amap_2d_limit_controller.dart';

class Flutter2dAMap {
  static const MethodChannel _channel =
      MethodChannel('plugins.weilu/flutter_2d_amap_');

  static String _webKey = '';
  static String get webKey => _webKey;

  static Future<bool?> setApiKey(
      {String iOSKey = '', String webKey = ''}) async {
    if (kIsWeb) {
      _webKey = webKey;
    } else {
      if (Platform.isIOS) {
        return _channel.invokeMethod<bool>('setKey', iOSKey);
      }
    }
    return Future.value(true);
  }
}
