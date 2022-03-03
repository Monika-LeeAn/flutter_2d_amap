//
//  ZYCityAnnotationView.h
//  flutter_2d_amap
//
//  Created by developer on 2022/3/3.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, ZYCityAnnotationViewAnimationDirection) {
    ZYCityAnnotationDirectionGrow,
    ZYCityAnnotationDirectionShrink,
};

typedef NS_ENUM(NSInteger, ZYCityAnnotationViewState) {
    ZYCityAnnotationViewStateCollapsed,
    ZYCityAnnotationViewStateExpanded,
    ZYCityAnnotationViewStateAnimating,
};

@interface ZYCityAnnotationView : MAAnnotationView
@property (nonatomic, strong) NSDictionary *modelDictionry;

@end

NS_ASSUME_NONNULL_END
