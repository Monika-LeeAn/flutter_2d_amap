//
//  ZYProvinceAnnotationView.h
//  flutter_2d_amap
//
//  Created by developer on 2022/3/1.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN
typedef void (^ZYProvinceAnnotationViewActionBlock)(void);

typedef NS_ENUM(NSInteger, ZYProvinceAnnotationViewAnimationDirection) {
    ZYProvinceViewAnimationDirectionGrow,
    ZYProvinceViewAnimationDirectionShrink,
};

typedef NS_ENUM(NSInteger, ZYProvinceAnnotationViewState) {
    ZYProvinceAnnotationViewStateCollapsed,
    ZYProvinceAnnotationViewStateExpanded,
    ZYProvinceAnnotationViewStateAnimating,
};

@interface ZYProvinceAnnotationView : MAAnnotationView
@property (nonatomic, strong) NSDictionary *modelDictionry;
@property (nonatomic, strong) ZYProvinceAnnotationViewActionBlock disclosureBlock;
@end

NS_ASSUME_NONNULL_END

