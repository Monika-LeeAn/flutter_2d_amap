

#import "FlutterAMap2DMultipleAnnotation.h"
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CustomAnnotationView.h"

#define kCalloutViewMargin          -8



@interface FlutterAMap2DMultipleAnnotationController() <AMapLocationManagerDelegate, AMapSearchDelegate, CLLocationManagerDelegate, MAMapViewDelegate>

@property (strong, nonatomic) CLLocationManager *mannger;
@property (strong, nonatomic) AMapLocationManager *locationManager;
@property (strong, nonatomic) AMapSearchAPI *search;
@property (nonatomic, strong) UIButton *gpsButton;
@property (nonatomic, strong) NSMutableArray *annotations;

@end

@implementation FlutterAMap2DMultipleAnnotationController{
    MAMapView* _mapView;
    int64_t _viewId;
    FlutterMethodChannel* _channel;
      
    MAPointAnnotation* _pointAnnotation;
    bool _isPoiSearch;
}

NSString* _types = @"010000|010100|020000|030000|040000|050000|050100|060000|060100|060200|060300|060400|070000|080000|080100|080300|080500|080600|090000|090100|090200|090300|100000|100100|110000|110100|120000|120200|120300|130000|140000|141200|150000|150100|150200|160000|160100|170000|170100|170200|180000|190000|200000";


- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger {
    if ([super init]) {

        _viewId = viewId;
        NSString* channelName = [NSString stringWithFormat:@"plugins.zhangyu/flutter_2d_multiple_annotation_%lld", viewId];
        _channel = [FlutterMethodChannel methodChannelWithName:channelName binaryMessenger:messenger];
        __weak __typeof__(self) weakSelf = self;
        [_channel setMethodCallHandler:^(FlutterMethodCall* call, FlutterResult result) {
            [weakSelf onMethodCall:call result:result];
        }];
        _isPoiSearch = [args[@"isPoiSearch"] boolValue] == YES;


            /// 初始化地图
            _mapView = [[MAMapView alloc] initWithFrame:self.view.frame];
            _mapView.delegate = self;
            _mapView.maxZoomLevel = 18.0;
            
            // 请求定位权限
            self.mannger =  [[CLLocationManager alloc] init];
            self.mannger.delegate = self;
            [self.mannger requestWhenInUseAuthorization];
            
            self.view.backgroundColor = UIColor.redColor;
            
            // [self.view addSubview:_mapView];
            
            self.gpsButton = [self makeGPSButtonView];
            self.gpsButton.center = CGPointMake(CGRectGetMidX(self.gpsButton.bounds) + 10,
                                                self.view.bounds.size.height -  CGRectGetMidY(self.gpsButton.bounds) - 20);
            [_mapView addSubview:self.gpsButton];
            self.gpsButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin;
            
            
            [self initAnnotations];

    
             [_mapView addAnnotations:self.annotations];
            [_mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];



    }
    return self;
}


- (UIView*)view {
    return _mapView;
}
 

- (void)initCityAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[10] = {
        {30.992520, 100.336170},
        {31.992520, 110.336170},
        {32.998293, 120.352343},
        {33.004087, 130.348904},
        {34.001442, 140.353915},
        {35.989105, 150.353915},
        {36.989098, 160.360200},
        {37.998439, 170.360201},
        {38.979590, 90.324219},
        {39.978234, 80.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"city: %d", i];
        
        [self.annotations addObject:a1];
    }
}


- (void)initAnnotations
{
    self.annotations = [NSMutableArray array];
    
    CLLocationCoordinate2D coordinates[10] = {
        {20.992520, 100.336170},
        {22.992520, 110.336170},
        {24.998293, 120.352343},
        {26.004087, 130.348904},
        {28.001442, 140.353915},
        {30.989105, 150.353915},
        {32.989098, 160.360200},
        {34.998439, 170.360201},
        {36.979590, 90.324219},
        {38.978234, 80.352792}};
    
    for (int i = 0; i < 10; ++i)
    {
        MAPointAnnotation *a1 = [[MAPointAnnotation alloc] init];
        a1.coordinate = coordinates[i];
        a1.title      = [NSString stringWithFormat:@"province: %d", i];
        
        [self.annotations addObject:a1];
    }
}

- (UIButton *)makeGPSButtonView {
    UIButton *ret = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
    ret.backgroundColor = [UIColor whiteColor];
    ret.layer.cornerRadius = 4;
    
    [ret setImage:[UIImage imageNamed:@"gpsStat1"] forState:UIControlStateNormal];
    [ret addTarget:self action:@selector(gpsAction) forControlEvents:UIControlEventTouchUpInside];
    
    return ret;
}


- (void)gpsAction {
    if(_mapView.userLocation.updating && _mapView.userLocation.location) {
        [_mapView setCenterCoordinate:_mapView.userLocation.location.coordinate animated:YES];
        [self.gpsButton setSelected:YES];
    }
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

            
//            [AMapLocationManager updatePrivacyShow:1 privacyInfo:1];
//            [AMapLocationManager updatePrivacyAgree:1];
            /// 初始化定位
            self.locationManager = [[AMapLocationManager alloc] init];
            self.locationManager.delegate = self;
            /// 开始定位
            [self.locationManager startUpdatingLocation];
            /// 初始化搜索
            self.search = [[AMapSearchAPI alloc] init];
            self.search.delegate = self;
            break;
        }
        default:
            NSLog(@"授权失败");
            break;
    }
}

#pragma mark 点击地图方法
- (void)mapView:(MAMapView *)mapView didSingleTappedAtCoordinate:(CLLocationCoordinate2D)coordinate {
    [self->_mapView setCenterCoordinate:coordinate animated:YES];
    [self drawMarkers:coordinate.latitude lon:coordinate.longitude];
    [self searchPOI:coordinate.latitude lon:coordinate.longitude];
}

//接收位置更新,实现AMapLocationManagerDelegate代理的amapLocationManager:didUpdateLocation方法，处理位置更新
- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode{

    NSLog(@"iOS端调用 amapLocationManager:(AMapLocationManager *)manager didUpdateLocation");
    // CLLocationCoordinate2D center;
    // center.latitude = location.coordinate.latitude;
    // center.longitude = location.coordinate.longitude;
    // [_mapView setZoomLevel:17 animated: YES];
    // [_mapView setCenterCoordinate:center animated:YES];
    // [self.locationManager stopUpdatingLocation];
    // [self searchPOI:location.coordinate.latitude lon:location.coordinate.longitude];
}

/* POI 搜索回调. */
- (void)onPOISearchDone:(AMapPOISearchBaseRequest *)request response:(AMapPOISearchResponse *)response{
    if (response.pois.count == 0) {
        NSDictionary* arguments = @{@"poiSearchResult" : @"[]"};
        
        ///channel
        ///[_channel invokeMethod:@"poiSearchResult" arguments:arguments];
        return;
    }
    
    //1. 初始化可变字符串，存放最终生成json字串
    NSMutableString *jsonString = [[NSMutableString alloc] initWithString:@"["];
    
    [response.pois enumerateObjectsUsingBlock:^(AMapPOI *obj, NSUInteger idx, BOOL *stop) {
        
        if (idx == 0) {
            CLLocationCoordinate2D center;
            center.latitude = obj.location.latitude;
            center.longitude = obj.location.longitude;
            [self->_mapView setZoomLevel:17 animated: YES];
            [self->_mapView setCenterCoordinate:center animated:YES];
            [self drawMarkers:obj.location.latitude lon:obj.location.longitude];
        }
        //2. 遍历数组，取出键值对并按json格式存放
        NSString *string  = [NSString stringWithFormat:@"{\"cityCode\":\"%@\",\"cityName\":\"%@\",\"provinceName\":\"%@\",\"title\":\"%@\",\"adName\":\"%@\",\"provinceCode\":\"%@\",\"latitude\":\"%f\",\"longitude\":\"%f\",\"address\":\"%@\"},", obj.citycode, obj.city, obj.province, obj.name, obj.district, obj.pcode, obj.location.latitude, obj.location.longitude, obj.address];

        [jsonString appendString:string];
        
    }];
    
    // 3. 获取末尾逗号所在位置
    NSUInteger location = [jsonString length] - 1;
    
    NSRange range = NSMakeRange(location, 1);
    
    // 4. 将末尾逗号换成结束的]
    [jsonString replaceCharactersInRange:range withString:@"]"];
    
    NSDictionary* arguments = @{
                                @"poiSearchResult" : jsonString
                                };
    ///[_channel invokeMethod:@"poiSearchResult" arguments:arguments];
}

//字典转Json
- (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData  *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

//- (UIView*)view {
//    return _mapView;
//}
    
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

- (void)searchPOI:(CGFloat)lat lon:(CGFloat)lon{
    
    // if (_isPoiSearch) {
    //     AMapPOIAroundSearchRequest *request = [[AMapPOIAroundSearchRequest alloc] init];
    //     request.types               = _types;
    //     request.requireExtension    = YES;
    //     request.offset              = 50;
    //     request.location            = [AMapGeoPoint locationWithLatitude:lat longitude:lon];
    //     [self.search AMapPOIAroundSearch:request];
    // }
}

- (void)onMethodCall:(FlutterMethodCall*)call result:(FlutterResult)result {
    if ([[call method] isEqualToString:@"search"]) {
        if (_isPoiSearch) {
            AMapPOIKeywordsSearchRequest *request = [[AMapPOIKeywordsSearchRequest alloc] init];
            request.types               = _types;
            request.requireExtension    = YES;
            request.offset              = 50;
            request.keywords            = [call arguments][@"keyWord"];
            request.city                = [call arguments][@"city"];
            [self.search AMapPOIKeywordsSearch:request];
        }
    } else if ([[call method] isEqualToString:@"move"]) {
        NSString* lat = [call arguments][@"lat"];
        NSString* lon = [call arguments][@"lon"];
        CLLocationCoordinate2D center;
        center.latitude = [lat doubleValue];
        center.longitude = [lon doubleValue];
        [self->_mapView setCenterCoordinate:center animated:YES];
        [self drawMarkers:[lat doubleValue] lon:[lon doubleValue]];
    } else if ([[call method] isEqualToString:@"location"]) {
        [self.locationManager startUpdatingLocation];
    }
}


- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id<MAAnnotation>)annotation
{
    BOOL isA = [annotation.title containsString:@"anno"];
    if( [annotation.title isEqualToString:@"用户点击位置"]) {
        static NSString *pointReuseIndetifier = @"pointReuseIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:pointReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:pointReuseIndetifier];
        }
        
        annotationView.canShowCallout               = YES;
        annotationView.animatesDrop                 = YES;
        annotationView.draggable                    = YES;
        annotationView.rightCalloutAccessoryView    = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        annotationView.pinColor                     = [self.annotations indexOfObject:annotation] % 3;
        
        return annotationView;
    }else if ([annotation.title containsString:@"province"]){
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        ProvinceAnnotationView *annotationView = (ProvinceAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[ProvinceAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        
        annotationView.itemCount = [NSNumber numberWithInt:[self getRandomNumber:1 to:1000]];
        
//        annotationView.portrait = [UIImage imageNamed:@"hema"];
//        annotationView.name     = @"省级视图";
//        annotation.
        return annotationView;
    } else if ([annotation.title containsString:@"city"]){
        
        static NSString *customReuseIndetifier = @"customReuseIndetifier";
        CustomAnnotationView *annotationView = (CustomAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:customReuseIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:customReuseIndetifier];
            // must set to NO, so we can show the custom callout view.
            annotationView.canShowCallout = NO;
            annotationView.draggable = YES;
            annotationView.calloutOffset = CGPointMake(0, -5);
        }
        annotationView.portrait = [UIImage imageNamed:@"hema"];
        annotationView.name     = @"城市城市";
        return annotationView;
    }
    
    
    return nil;
}


- (void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    /* Adjust the map center in order to show the callout view completely. */
    if ([view isKindOfClass:[CustomAnnotationView class]]) {
        CustomAnnotationView *cusView = (CustomAnnotationView *)view;
        CGRect frame = [cusView convertRect:cusView.calloutView.frame toView:_mapView];
        
        frame = UIEdgeInsetsInsetRect(frame, UIEdgeInsetsMake(kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin, kCalloutViewMargin));
        if (!CGRectContainsRect(_mapView.frame, frame))
        {
            /* Calculate the offset to make the callout view show up. */
            CGSize offset = [self offsetToContainRect:frame inRect:_mapView.frame];
            
            CGPoint theCenter = _mapView.center;
            theCenter = CGPointMake(theCenter.x - offset.width, theCenter.y - offset.height);
            
            CLLocationCoordinate2D coordinate = [_mapView convertPoint:theCenter toCoordinateFromView:_mapView];
            
            [_mapView setCenterCoordinate:coordinate animated:YES];
        }
        
    }
}

- (CGSize)offsetToContainRect:(CGRect)innerRect inRect:(CGRect)outerRect
{
    CGFloat nudgeRight = fmaxf(0, CGRectGetMinX(outerRect) - (CGRectGetMinX(innerRect)));
    CGFloat nudgeLeft = fminf(0, CGRectGetMaxX(outerRect) - (CGRectGetMaxX(innerRect)));
    CGFloat nudgeTop = fmaxf(0, CGRectGetMinY(outerRect) - (CGRectGetMinY(innerRect)));
    CGFloat nudgeBottom = fminf(0, CGRectGetMaxY(outerRect) - (CGRectGetMaxY(innerRect)));
    return CGSizeMake(nudgeLeft ?: nudgeRight, nudgeTop ?: nudgeBottom);
}


/**
 * @brief 地图将要发生缩放时调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapWillZoomByUser:(BOOL)wasUserAction {
    
    if (wasUserAction) {
        NSLog(@"查看缩放 将要开始");
        NSLog(@"%f -- %f -- %f", _mapView.zoomLevel, _mapView.minZoomLevel, _mapView.maxZoomLevel);
    }
}

/**
 * @brief 地图缩放结束后调用此接口
 * @param mapView       地图view
 * @param wasUserAction 标识是否是用户动作
 */
- (void)mapView:(MAMapView *)mapView mapDidZoomByUser:(BOOL)wasUserAction {
    if (wasUserAction) {
        NSLog(@"查看缩放 将要结束");
        NSLog(@"%e -- %e -- %e", _mapView.zoomLevel, _mapView.minZoomLevel, _mapView.maxZoomLevel);
        
//        if (_mapView.zoomLevel >= 3 && _mapView.zoomLevel < 5){
//            [_mapView removeAnnotations:_mapView.annotations];
//
//            [self initCityAnnotations];
//            [_mapView addAnnotations:self.annotations];
////            [_mapView showAnnotations:self.annotations edgePadding:UIEdgeInsetsMake(20, 20, 20, 80) animated:YES];
//        }
    }
}

-(int)getRandomNumber:(int)from to:(int)toInt {
    int fix = toInt - from;
    return (int)(from + (arc4random() % (fix + 1)));

}

@end



@implementation FlutterAMap2DMultipleAnnotationFactory {
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
    FlutterAMap2DMultipleAnnotationController* aMap2DMultipleAnnotaitonController = [[FlutterAMap2DMultipleAnnotationController alloc] initWithFrame:frame
                                                                                viewIdentifier:viewId
                                                                                     arguments:args
                                                                               binaryMessenger:_messenger];
    return aMap2DMultipleAnnotaitonController;
}
    



@end
