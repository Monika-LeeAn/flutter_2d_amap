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

#import <AMapLocationKit/AMapLocationKit.h>

@interface FlutterAMap2DLimitController() <AMapLocationManagerDelegate, CLLocationManagerDelegate, MAMapViewDelegate, AMapGeoFenceManagerDelegate>

@property (strong, nonatomic) CLLocationManager *mannger;
@property (strong, nonatomic) AMapLocationManager *locationManager;

@property (nonatomic, strong) NSMutableArray *annotations;

@property (nonatomic, assign) BOOL isNotifyLocation;

@property (nonatomic, strong) NSMutableArray *flutterToMapAnnotationsModels;

@property (nonatomic, strong) NSArray *circles;

@property (nonatomic, strong)AMapGeoFenceManager *geoFenceManager;

@property (nonatomic, strong) NSDate* theDate;
@end



@implementation FlutterAMap2DLimitController {
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
      
}




- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {
        
        
        _isNotifyLocation = true;
      
        _theDate = [NSDate date];

        
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
        
            
//            // 请求定位权限
//            self.mannger =  [[CLLocationManager alloc] init];
//            self.mannger.delegate = self;
//            [self.mannger requestWhenInUseAuthorization];
        
        
        
        
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

            //地理围栏
        self.geoFenceManager = [[AMapGeoFenceManager alloc] init];
        self.geoFenceManager.delegate = self;
        self.geoFenceManager.activeAction = AMapGeoFenceActiveActionInside | AMapGeoFenceActiveActionOutside | AMapGeoFenceActiveActionStayed; //设置希望侦测的围栏触发行为，默认是侦测用户进入围栏的行为，即AMapGeoFenceActiveActionInside，这边设置为进入，离开，停留（在围栏内10分钟以上），都触发回调
        self.geoFenceManager.allowsBackgroundLocationUpdates = YES;  //允许后台定位

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

//1、获取围栏创建后的回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didAddRegionForMonitoringFinished:(NSArray<AMapGeoFenceRegion *> *)regions customID:(NSString *)customID error:(NSError *)error {
    if (error) {
        NSLog(@"创建失败 %@",error);
    } else {
        NSLog(@"创建成功---%@", customID);
        
        BOOL isS = [manager startTheGeoFenceRegion:regions.firstObject];
        
        NSLog(@"开始??? ");

    }
}


//2、围栏状态改变时的回调
- (void)amapGeoFenceManager:(AMapGeoFenceManager *)manager didGeoFencesStatusChangedForRegion:(AMapGeoFenceRegion *)region customID:(NSString *)customID error:(NSError *)error {
    
    
    //
    NSLog(@"围栏状态---%@", customID);

    if (error) {
        NSLog(@"status changed error %@",error);
    }else{
        NSNumber *num = @0;
        if (region.regionType == AMapGeoFenceRegionStatusUnknown) {
            num = @0;
        } else if  (region.regionType == AMapGeoFenceRegionStatusInside) {
            num = @1;
        } else if  (region.regionType == AMapGeoFenceRegionStatusOutside) {
            num = @2;
        }else if  (region.regionType == AMapGeoFenceRegionStatusStayed) {
            num = @3;
        }
        
        NSDictionary* arguments = @{
            @"fenceStatus": num,
            @"customID":region.customID
        };
        [_channel invokeMethod:@"regionsCallBack" arguments:arguments];
        NSLog(@"status changed success --%@--- %@",customID,[region description]);
    }
}


//最后，移除围栏

//- (void)removeTheGeoFenceRegion:(AMapGeoFenceRegion *)region; //移除指定围栏
//- (void)removeGeoFenceRegionsWithCustomID:(NSString *)customID; //移除指定customID的围栏
//- (void)removeAllGeoFenceRegions;  //移除所有围栏


//- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode {
//
//    NSLog(@"位置发生改变了");
//}


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
    
    
    [_mapView setZoomLevel:17 animated: YES];
    CLLocationCoordinate2D center;
    center.latitude = location.coordinate.latitude;
    center.longitude = location.coordinate.longitude;
    [_mapView setCenterCoordinate:center animated:YES];
    
    if (_isNotifyLocation) {
        NSDictionary* arguments = @{
                                    @"lat" : [NSNumber numberWithDouble:_mapView.centerCoordinate.latitude],
                                    @"lng" : [NSNumber numberWithDouble:_mapView.centerCoordinate.longitude],
                                    };
        [_channel invokeMethod:@"didUpdateLocation" arguments:arguments];
        
        _isNotifyLocation= false;
    }
    
    
//    _theDate = [NSDate date];
    NSDate *now = [NSDate date];
    NSDateFormatter *fmt = [[NSDateFormatter alloc]init];
   //日历对象（方便比较两个日期之间的差距）
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // NSCalendarUnit 枚举代表想获得哪些差值
    NSCalendarUnit unit = NSCalendarUnitYear |NSCalendarUnitWeekOfMonth |NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute |NSCalendarUnitSecond;
   //计算两个日期之间的差值
    NSDateComponents *cmps = [calendar components:unit fromDate:_theDate toDate:now  options:0];
    
    
    NSString *str =  [NSString stringWithFormat:@"%ld秒钟前", cmps.second];
    
    NSLog(@"%@", str);
    if (cmps.second > 5) {
        _theDate = [NSDate date];
        NSDictionary* arguments = @{
                                    @"lat" : [NSNumber numberWithDouble:_mapView.centerCoordinate.latitude],
                                    @"lng" : [NSNumber numberWithDouble:_mapView.centerCoordinate.longitude],
                                    };
        [_channel invokeMethod:@"noty_didUpdateLocation" arguments:arguments];
    }
  
    
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


- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"location"]) {
        [self.locationManager startUpdatingLocation];
        
        [_mapView setZoomLevel:15 animated:true];
    } else if ([[call method] isEqualToString:@"setAnnomations"]){
        [_mapView removeAnnotations:self.annotations];
        NSLog(@"iOS端收到了 FLutter端 发送的setAnnomations方法");
        NSMutableArray *mArray = [call arguments][@"entities"];
        self.flutterToMapAnnotationsModels = [mArray mutableCopy];
        [self initAnnotations:mArray ];
        [_mapView addOverlays:self.circles];
        [_mapView setZoomLevel:15.0 animated:true];
    } else if ([[call method] isEqualToString:@"getRegionsStatus"]) {
        
        
        NSArray *array =  [_geoFenceManager geoFenceRegionsWithCustomID:nil];
        
        NSLog(@"~~~");
    }
}


- (void)initAnnotations:(NSMutableArray *)annotationsFormFlutter {
    self.annotations = [NSMutableArray array];
    
    NSMutableArray *arr = [NSMutableArray array];

        
    for (int i = 0; i < annotationsFormFlutter.count; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        
        //[5]    (null)    @"gpsLatitude" : @"31.243"
        //[0]    (null)    @"gpsLongitude" : @"121.5092"
        double lat = [annotationsFormFlutter[i][@"gpsLatitude"] doubleValue];
        double lng = [annotationsFormFlutter[i][@"gpsLongitude"] doubleValue];
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(lat, lng);
        
        MACircle *circle1 = [MACircle circleWithCenterCoordinate:coordinate radius:200];
        [arr addObject:circle1];

        
        [self.geoFenceManager addCircleRegionForMonitoringWithCenter:coordinate radius:5000 customID:[NSString stringWithFormat:@"cirle_%d", i]];
    }
    
    
    [_mapView addOverlays:arr];
    
//    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(39.908692, 116.397477); //天安门
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
