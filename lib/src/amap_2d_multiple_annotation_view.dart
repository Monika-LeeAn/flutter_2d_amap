import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_multiple_annotation_controller.dart';
import 'package:flutter_2d_amap/src/mobile/amap_2d_multiple_annotation_controller.dart';
import 'mobile/amap_2d_multiple_annotation_view_state.dart';

typedef AMap2DMultipleAnnotationViewCreatedCallback = void Function(
    AMap2DMultipleAnnotationController controller);

class AMap2DMultipleAnnotationView extends StatefulWidget {
  const AMap2DMultipleAnnotationView({
    Key? key,
    this.onAMap2DViewCreated,
  }) : super(key: key);

  final AMap2DMultipleAnnotationViewCreatedCallback? onAMap2DViewCreated;

  @override
  AMap2DMobileMultipleAnnotationState createState() =>
      AMap2DMobileMultipleAnnotationState();
}
