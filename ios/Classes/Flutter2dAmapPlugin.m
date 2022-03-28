#import "Flutter2dAmapPlugin.h"
#import "AMapFoundationKit/AMapFoundationKit.h"
#import "FlutterAMap2D.h"
#import "FlutterAMap2DMultipleAnnotation.h"
#import "FlutterAMap2DLimit.h"
@implementation Flutter2dAmapPlugin

/// 每个组件通过实现该方法拿到FlutterPluginRegistrar进而拿到FlutterBinaryMessenger对象
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {


  ///1.FlutterMethodChannel 接收Flutter传递过来的方法
  FlutterMethodChannel* channel = [FlutterMethodChannel
      methodChannelWithName:@"plugins.weilu/flutter_2d_amap_"
            binaryMessenger:[registrar messenger]];

  ///2.instance是插件实例
  Flutter2dAmapPlugin* instance = [[Flutter2dAmapPlugin alloc] init];

  ///3.registrar 绑定 插件实例 和 channel
  [registrar addMethodCallDelegate:instance channel:channel];


  ///4.添加一个自定义视图 然后给registrar注册自定义视图
  FlutterAMap2DFactory* aMap2DFactory =
  [[FlutterAMap2DFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:aMap2DFactory withId:@"plugins.weilu/flutter_2d_amap"];


  ///5.添加第二个自定义视图 然后给registrar注册自定义视图
  FlutterAMap2DMultipleAnnotationFactory* aMap2DMultipleAnnotationFactory =
  [[FlutterAMap2DMultipleAnnotationFactory alloc] initWithMessenger:registrar.messenger];
  [registrar registerViewFactory:aMap2DMultipleAnnotationFactory withId:@"plugins.zhangyu/flutter_2d_multiple_annotation_uiview"];
    
    
    //6.地理围栏
    FlutterAMap2DLimitFactory* aMap2DLimitFactory =
    [[FlutterAMap2DLimitFactory alloc] initWithMessenger:registrar.messenger];
    [registrar registerViewFactory:aMap2DLimitFactory withId:@"plugins.zhangyu/flutter_2d_limit_uiview"];

}

- (void)handleMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
  if ([@"setKey" isEqualToString:call.method]) {
    NSString *key = call.arguments;
    [AMapServices sharedServices].enableHTTPS = YES;
    // 配置高德地图的key
    [AMapServices sharedServices].apiKey = key;
    result(@YES);
  } else {
    result(FlutterMethodNotImplemented);
  }
}

@end
