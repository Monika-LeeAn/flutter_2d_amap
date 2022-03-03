import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_controller.dart';
import 'package:flutter_2d_amap/src/interface/amap_2d_multiple_annotation_controller.dart';
import 'package:flutter_2d_amap/src/mobile/amap_2d_multiple_annotation_controller.dart';
import 'mobile/amap_2d_multiple_annotation_view_state.dart';

typedef AMap2DMultipleAnnotationViewCreatedCallback = void Function(
    AMap2DMultipleAnnotationController controller);

typedef AMap2DMultipleAnnotationViewRatioChangeCallBack = void Function(
    AMap2DMultipleAnnotationController controller, Map args);

typedef AMap2DMultipleAnnotationViewDidClickAnnotationCallBack = void Function(
    AMap2DMultipleAnnotationController controller, Map args);

typedef AMap2DMultipleAnnotationViewDidSingleTappedAtCoordinate = void Function(
    AMap2DMultipleAnnotationController controller, Map args);

class AMap2DMultipleAnnotationView extends StatefulWidget {
  const AMap2DMultipleAnnotationView({
    Key? key,
    this.onAMap2DViewCreated,
    this.onAmap2DViewRatioChanged,
    this.didClickAnnotationCallBack,
    this.didSingleTappedAtCoordinate,
  }) : super(key: key);

  final AMap2DMultipleAnnotationViewCreatedCallback? onAMap2DViewCreated;

  final AMap2DMultipleAnnotationViewRatioChangeCallBack?
      onAmap2DViewRatioChanged;

  final AMap2DMultipleAnnotationViewDidClickAnnotationCallBack?
      didClickAnnotationCallBack;

  final AMap2DMultipleAnnotationViewDidSingleTappedAtCoordinate?
      didSingleTappedAtCoordinate;

  @override
  AMap2DMobileMultipleAnnotationState createState() =>
      AMap2DMobileMultipleAnnotationState();
}
