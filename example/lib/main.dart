import 'package:flutter/material.dart';
import 'package:flutter_2d_amap/flutter_2d_amap.dart';
import 'package:flutter_2d_amap_example/custom_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Flutter2dAMap.setApiKey(
    iOSKey: '1a8f6a489483534a9f2ca96e4eeeb9b3',
    webKey: '4e479545913a3a180b3cffc267dad646',
  ).then((value) => runApp(const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<PoiSearch> _list = [];
  int _index = 0;
  final ScrollController _controller = ScrollController();
  late AMap2DMultipleAnnotationController _aMap2DController;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SecondViewPage());
  }
}
