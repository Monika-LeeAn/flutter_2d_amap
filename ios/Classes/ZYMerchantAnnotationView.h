//
//  ZYMerchantAnnotationView.h
//  flutter_2d_amap
//
//  Created by developer on 2022/3/3.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>

NS_ASSUME_NONNULL_BEGIN



@interface ZYMerchantAnnotationView : MAAnnotationView
@property (nonatomic, strong) NSDictionary *modelDictionry;
//@property (nonatomic, strong) ZYCityAnnotationViewActionBlock disclosureBlock;
@end

NS_ASSUME_NONNULL_END
