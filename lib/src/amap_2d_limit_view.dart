import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_limit_controller.dart';

import 'package:flutter_2d_amap/src/mobile/amap_2d_limit_state.dart';

import 'model/poi_search_model.dart';

typedef AMap2DLimitViewCreatedCallback = void Function(
    AMap2DLimitController controller, Map<dynamic, dynamic>);

typedef AMap2DLimitViewRegionStatusCallback = void Function(
    AMap2DLimitController controller, Map<dynamic, dynamic>);

typedef AMap2DLimitViewLocationUpdateCallback = void Function(
    AMap2DLimitController controller, Map<dynamic, dynamic>);

typedef AMap2DLimitViewLocatioJustShowCompanyCallback = void Function(
    AMap2DLimitController controller);

class AMap2DLimitView extends StatefulWidget {
  const AMap2DLimitView({
    Key? key,
    this.isPoiSearch = true,
    this.onPoiSearched,
    this.onAMap2DViewCreated,
    this.onAmap2DLimitRegionStatusChanged,
    this.onAmap2DLimitLocationUpdateChanged,
    this.onAmap2DLimitJustShowCompany,
  }) : super(key: key);

  final bool isPoiSearch;
  final AMap2DLimitViewCreatedCallback? onAMap2DViewCreated;
  final AMap2DLimitViewRegionStatusCallback? onAmap2DLimitRegionStatusChanged;
  final AMap2DLimitViewLocationUpdateCallback?
      onAmap2DLimitLocationUpdateChanged;
  final AMap2DLimitViewLocatioJustShowCompanyCallback?
      onAmap2DLimitJustShowCompany;

  final Function(List<PoiSearch>)? onPoiSearched;

  @override
  AMap2DLimitViewState createState() => AMap2DLimitViewState();
}
