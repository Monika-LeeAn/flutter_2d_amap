//
//  FlutterAMap2DLimit.m
//  flutter_2d_amap
//
//  Created by developer on 2022/3/25.
//

#import "FlutterAMap2DLimit.h"

#import "FlutterAMap2DMultipleAnnotation.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CustomAnnotationView.h"
#import "ZYProvinceAnnotationView.h"
#import "ZYCityAnnotationView.h"
#import "ZYMerchantAnnotationView.h"


@interface FlutterAMap2DLimitController() <AMapLocationManagerDelegate, CLLocationManagerDelegate, MAMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *mannger;
@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, strong) NSNumber *startLevel;
@property (nonatomic, strong) NSNumber *endLevel;

@property (nonatomic, strong) NSMutableArray *flutterToMapAnnotationsModels;
@property (nonatomic, copy) NSString *currentLevel;

@property (nonatomic, strong) NSArray *circles;

@end



@implementation FlutterAMap2DLimitController {
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
      
    MAPointAnnotation* _pointAnnotation;
}


- (void)initCircles {
    NSMutableArray *arr = [NSMutableArray array];
    /* Circle. */
    MACircle *circle1 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(31.245105, 121.516377) radius:200];
    [arr addObject:circle1];
    
    
    MACircle *circle2 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(31.244105, 121.510377) radius:200];
    [arr addObject:circle2];
    
    MACircle *circle3 = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(31.245105, 121.496377) radius:200];
    [arr addObject:circle3];
    
    
    self.circles = [NSArray arrayWithArray:arr];
}


- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {

        _endLevel = [NSNumber numberWithInt:1];

        [self initCircles];
        
        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"plugins.zhangyu/flutter_2d_limit_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];

            /// 初始化地图
            _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
            _mapView.delegate = self;
            _mapView.maxZoomLevel = 18.0;
            _mapView.minZoomLevel = 3;
            [_mapView setZoomLevel:12.0 animated:true];
            
            // 请求定位权限
            self.mannger =  [[CLLocationManager alloc] init];
            self.mannger.delegate = self;
            [self.mannger requestWhenInUseAuthorization];
    }
    return self;
}


- (UIView*)view {
    return _mapView;
}
 

- (UIButton *)getmerChantButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    return ret;
}




-(void)locationManager:(CLLocationManager *)manager didChangeAuthorizationStatus:(CLAuthorizationStatus)status {
    switch (status) {
        case kCLAuthorizationStatusAuthorizedAlways:
        case kCLAuthorizationStatusAuthorizedWhenInUse:{
            ///如果您需要进入地图就显示定位小蓝点，则需要下面两行代码
            _mapView.showsUserLocation = YES;
            _mapView.userTrackingMode = MAUserTrackingModeFollow;
            _mapView.showTraffic = FALSE;
            _mapView.compassOrigin= CGPointMake(_mapView.compassOrigin.x, 52); //设置指南针位置
            _mapView.scaleOrigin= CGPointMake(_mapView.scaleOrigin.x + 20, _mapView.frame.size.height - 30);  //设置比例尺位置

            /// 初始化定位
            self.locationManager = [[AMapLocationManager alloc] init];
            self.locationManager.delegate = self;
            /// 开始定位
            [self.locationManager startUpdatingLocation];
            /// 初始化搜索
           
            _mapView.zoomLevel = 15;
            
            [_mapView setZoomLevel:15.0 animated:true];
            
            break;
        }
        default:
            NSLog(@"授权失败");
            break;
    }
}

- (MAOverlayRenderer *)mapView:(MAMapView *)mapView rendererForOverlay:(id <MAOverlay>)overlay
{
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleRenderer *circleRenderer = [[MACircleRenderer alloc] initWithCircle:overlay];
        
        circleRenderer.lineWidth   = 4.f;
        circleRenderer.strokeColor = [UIColor blueColor];
        
        NSInteger index = [self.circles indexOfObject:overlay];
        if(index == 0) {
            circleRenderer.fillColor   = [[UIColor redColor] colorWithAlphaComponent:0.3];
        } else if(index == 1) {
            circleRenderer.fillColor   = [[UIColor greenColor] colorWithAlphaComponent:0.3];
        } else if(index == 2) {
            circleRenderer.fillColor   = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        } else {
            circleRenderer.fillColor   = [[UIColor yellowColor] colorWithAlphaComponent:0.3];
        }
        
        return circleRenderer;
    }
    
    return nil;
}




//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{
    NSLog(@"iOS端调用 amapLocationManager:(AMapLocationManager *)manager didUpdateLocation");
    
    
    
}


//字典转Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}


//检查是否授予定位权限
- (bool)hasPermission{
    CLAuthorizationStatus locationStatus =  [CLLocationManager authorizationStatus];
    return (bool)(locationStatus == kCLAuthorizationStatusAuthorizedWhenInUse || locationStatus == kCLAuthorizationStatusAuthorizedAlways);
}

- (void)drawMarkers:(CGFloat)lat lon:(CGFloat)lon {
    if (self->_pointAnnotation == NULL) {
        self->_pointAnnotation = [[MAPointAnnotation alloc] init];
        self->_pointAnnotation.title = @"用户点击位置";
        self->_pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
        [self->_mapView addAnnotation:self->_pointAnnotation];
    } else {
        self->_pointAnnotation.coordinate = CLLocationCoordinate2DMake(lat, lon);
    }
}



- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"location"]) {
        [self.locationManager startUpdatingLocation];
    } else if ([[call method] isEqualToString:@"setAnnomations"]){
        [_mapView removeAnnotations:self.annotations];
        NSLog(@"iOS端收到了 FLutter端 发送的setAnnomations方法");
        
        NSMutableArray *mArray = [call arguments][@"entities"];
        NSString *customMapLevel= [call arguments][@"customMapLevel"];
        
        _currentLevel = customMapLevel;

        self.flutterToMapAnnotationsModels = [mArray mutableCopy];
        [self initAnnotations:mArray level:customMapLevel];
        
        // [_mapView addAnnotations:self.annotations];
        // [_mapView showAnnotations:self.annotations  animated:YES];
        [_mapView addOverlays:self.circles];
        
        [_mapView setZoomLevel:15.0 animated:true];
    }
}

- (void)initAnnotations:(NSMutableArray *)annotationsFormFlutter level:(NSString *)customMapLevel
{
    self.annotations = [NSMutableArray array];
        
    for (int i = 0; i < annotationsFormFlutter.count; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        double lat = [annotationsFormFlutter[i][@"latitude"] doubleValue];
        double lng = [annotationsFormFlutter[i][@"longitude"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        a1.coordinate = coordinate;
        if ([customMapLevel  isEqual: @"1"]){
                a1.title      = [NSString stringWithFormat:@"province:%d", i];
        } else if ([customMapLevel isEqual: @"2"]){
                a1.title      = [NSString stringWithFormat:@"city:%d", i];
        } else if ([customMapLevel isEqual: @"3"]){
                a1.title      = [NSString stringWithFormat:@"merchant:%d", i];
        }
        [self.annotations addObject:a1];
    }
}


//- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
//{
//    static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
//    MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
//    if (annotationView == nil)
//    {
//        annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
//    }
//
//    annotationView.canShowCallout               = YES;
//    annotationView.animatesDrop                 = YES;
//    annotationView.draggable                    = YES;
//    annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
//    annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
//    return annotationView;
//
//}



//- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
//{
//    [_mapView setCenterCoordinate:view.annotation.coordinate animated:YES];
//}


-(int)getRandomNumber:(int)from to:(int)toInt {
    int fix = toInt - from;
    return (int)(from + (arc4random() % (fix + 1)));

}

@end



@implementation FlutterAMap2DLimitFactory {
    NSObject<FlutterBinaryMessenger>* _messenger;
}
    
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    self = [super init];
    if (self) {
        _messenger = messenger;
    }
    return self;
}

///#pragma mark -- 实现FlutterPlatformViewFactory 的代理方法

/**
 * Returns the `FlutterMessageCodec` for decoding the args parameter of `createWithFrame`.
 * 返回用于解码`createWithFrame`的args参数的`FlutterMessageCodec`
 * Only needs to be implemented if `createWithFrame` needs an arguments parameter.
 * 只有在`createWithFrame`需要一个参数时才需要实现。
 */
- (NSObject<FlutterMessageCodec>*)createArgsCodec {
    return [FlutterStandardMessageCodec sharedInstance];
}


/// FlutterPlatformViewFactory 代理方法 返回过去一个类来布局 原生视图
/// @param frame frame
/// @param viewId view的id
/// @param args 初始化的参数
- (NSObject<FlutterPlatformView>*)createWithFrame:(CGRect)frame
                                   viewIdentifier:(int64_t)viewId
                                        arguments:(id _Nullable)args {
    FlutterAMap2DLimitController *aFlutterAMap2DLimitController = [
        [FlutterAMap2DLimitController alloc] initWithFrame:frame
                                                                                viewIdentifier:viewId
                                                                                     arguments:args
                                                                               binaryMessenger:_messenger];
    return aFlutterAMap2DLimitController;
}
    



@end
