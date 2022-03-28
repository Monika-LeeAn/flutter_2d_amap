//
//  FlutterAMap2DLimit.h
//  flutter_2d_amap
//
//  Created by developer on 2022/3/25.
//

#import <Foundation/Foundation.h>

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

@interface FlutterAMap2DLimitController : NSObject<FlutterPlatformView>

- (instancetype)initWithFrame:(CGRect)frame
               viewIdentifier:(int64_t)viewId
                    arguments:(id _Nullable)args
              binaryMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
    
- (UIView*)view;

- (void)amapLocationManager:(AMapLocationManager *)manager didUpdateLocation:(CLLocation *)location reGeocode:(AMapLocationReGeocode *)reGeocode;
@end

NS_ASSUME_NONNULL_END


@interface FlutterAMap2DLimitFactory : NSObject<FlutterPlatformViewFactory>
- (instancetype)initWithMessenger:(NSObject<FlutterBinaryMessenger>*)messenger;
@end
