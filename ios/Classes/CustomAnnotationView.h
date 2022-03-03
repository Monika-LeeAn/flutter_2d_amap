//
//  CustomAnnotationView.h
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>

@interface CustomAnnotationView : MAAnnotationView

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) UIImage *portrait;

@property (nonatomic, strong) UIView *calloutView;

@end



@interface ProvinceAnnotationView : MAAnnotationView

@property (nonatomic, strong) NSNumber *itemCount;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *countLabel;

@property (nonatomic, strong) NSDictionary *modelDictionry;

@end


@interface CityAnnotationView : MAAnnotationView

@property (nonatomic, strong) NSNumber *itemCount;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSDictionary *modelDictionry;

@end


@interface MerchantAnnotationView : MAAnnotationView

@property (nonatomic, strong) NSNumber *itemCount;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) NSDictionary *modelDictionry;

@end
