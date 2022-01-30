
#import <Flutter/Flutter.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <MAMapKit/MAMapKit.h>
#import <AMapFoundationKit/AMapFoundationKit.h>
#import <CoreLocation/CoreLocation.h>
#import <AMapLocationKit/AMapLocationKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <CoreGraphics/CoreGraphics.h>
#import "CustomAnnotationView.h"

NS_ASSUME_NONNULL_BEGIN

@interface FlutterAMap2DMultipleAnnotationController : NSObject<FlutterPlatformView>
    
- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
    
- (UIView*)view;

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;

@end


@interface FlutterAMap2DMultipleAnnotationFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end




NS_ASSUME_NONNULL_END







