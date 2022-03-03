import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';

class SecondViewPage extends StatefulWidget {
  @override
  _SecondViewPageState createState() => _SecondViewPageState();
}

class _SecondViewPageState extends State<SecondViewPage> {
  late AMap2DMultipleAnnotationController? _aMap2DController;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('flutter_2d_amap'),
      ),
      body: SafeArea(
          child: Stack(
        children: [
          AMap2DMultipleAnnotationView(
            didSingleTappedAtCoordinate: (controller, args) {
              print('这里打印传递过来的参数 $args');
            },
            didClickAnnotationCallBack: (controller, args) {
              print('这里打印传递过来的参数 $args');
            },
            onAMap2DViewCreated: (controller) {
              _aMap2DController = controller;
            },
            onAmap2DViewRatioChanged: (controller, args) {
              print('我在设置的回调方法中发现了,地图的比例尺发生了变化');
              //flutter: {lat: 32.89999696880566, lng: 113.2234269673306, ratioLevel: 1}
              print(args);
              // controller.move(lat, lon);
              ///{lat: 25.678315360996322, lng: 117.32948434831536, ratioLevel: 2}
              // print(provice1);
            },
          ),
          Positioned(
            right: 10,
            left: 10,
            bottom: 100.0,
            child: Container(
              color: Colors.blue,
              child: const Text('第一个组件'),
            ),
          ),
          Positioned(
            child: MaterialButton(
              child: const Text('给地图设置标注'),
              onPressed: () {
                print('准备调用 给地图设置标注的方法');
                _aMap2DController?.setAnnomations(provice1, '1');
              },
            ),
          )
        ],
      )),
    );
  }

  Widget createCard() {
    return const Padding(
      padding: EdgeInsets.only(left: 12, right: 12),
      child: Card(
        child: Text('123_123'),
        // elevation: 12,
      ),
    );
  }
}

var provice1 = [
  {
    'provinceCode': '960000',
    'provinceName': '四川省',
    'longitude': 104.065735,
    'latitude': 30.659462,
    'merchantNum': 3
  },
  {
    'provinceCode': '980000',
    'provinceName': '河南省',
    'longitude': 113.665413,
    'latitude': 34.757977,
    'merchantNum': 226
  },
  {
    'provinceCode': '1010000',
    'provinceName': '北京市',
    'longitude': 116.405289,
    'latitude': 39.904987,
    'merchantNum': 550
  },
  {
    'provinceCode': '1100000',
    'provinceName': '上海市',
    'longitude': 121.472641,
    'latitude': 31.231707,
    'merchantNum': 1500
  },
  {
    'provinceCode': '1050000',
    'provinceName': '江苏省',
    'longitude': 118.76741,
    'latitude': 32.041546,
    'merchantNum': 45
  }
];
