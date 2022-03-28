import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_limit_controller.dart';

import 'package:flutter_2d_amap/src/mobile/amap_2d_limit_state.dart';

import 'model/poi_search_model.dart';

typedef AMap2DLimitViewCreatedCallback = void Function(
    AMap2DLimitController controller);

class AMap2DLimitView extends StatefulWidget {
  const AMap2DLimitView({
    Key? key,
    this.isPoiSearch = true,
    this.onPoiSearched,
    this.onAMap2DViewCreated,
  }) : super(key: key);

  final bool isPoiSearch;
  final AMap2DLimitViewCreatedCallback? onAMap2DViewCreated;
  final Function(List<PoiSearch>)? onPoiSearched;

  @override
  AMap2DLimitViewState createState() => AMap2DLimitViewState();
}
