abstract class AMap2DMultipleAnnotationController {
  ///使用户点击的维持,成为中心点
  Future<void> move(String lat, String lon);

  ///获取用户当前定位的方法
  Future<void> location();
}
