abstract class AMap2DLimitController {
  Future<void> location();

  ///设置标注集合
  Future<void> setAnnomations(List entities, String level);

  Future<void> getRegionsStatus();

  Future<void> setCompany(String lat, String lon, String lat2, String lon2);
}
