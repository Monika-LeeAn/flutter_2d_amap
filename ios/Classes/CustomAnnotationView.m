//
//  CustomAnnotationView.m
//  CustomAnnotationDemo
//
//  Created by songjian on 13-3-11.
//  Copyright (c) 2013年 songjian. All rights reserved.
//

#import "CustomAnnotationView.h"
#import "CustomCalloutView.h"

#define kWidth  150.f
#define kHeight 60.f

#define kHoriMargin 5.f
#define kVertMargin 5.f

#define kPortraitWidth  50.f
#define kPortraitHeight 50.f

#define kCalloutWidth   200.0
#define kCalloutHeight  70.0

@interface CustomAnnotationView ()

@property (nonatomic, strong) UIImageView *portraitImageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

@implementation CustomAnnotationView

@synthesize calloutView;
@synthesize portraitImageView   = _portraitImageView;
@synthesize nameLabel           = _nameLabel;

#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override

- (NSString *)name
{
    return self.nameLabel.text;
}

- (void)setName:(NSString *)name
{
    self.nameLabel.text = name;
}



- (UIImage *)portrait
{
    return self.portraitImageView.image;
}

- (void)setPortrait:(UIImage *)portrait
{
    self.portraitImageView.image = portrait;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }
    
    if (selected)
    {
        if (self.calloutView == nil)
        {
            /* Construct custom callout. */
            self.calloutView = [[CustomCalloutView alloc] initWithFrame:CGRectMake(0, 0, kCalloutWidth, kCalloutHeight)];
            self.calloutView.center = CGPointMake(CGRectGetWidth(self.bounds) / 2.f + self.calloutOffset.x,
                                                  -CGRectGetHeight(self.calloutView.bounds) / 2.f + self.calloutOffset.y);
            
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            btn.frame = CGRectMake(10, 10, 40, 40);
            [btn setTitle:@"Test" forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
            [btn setBackgroundColor:[UIColor whiteColor]];
            [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
            
            [self.calloutView addSubview:btn];
            
            UILabel *name = [[UILabel alloc] initWithFrame:CGRectMake(60, 10, 100, 30)];
            name.backgroundColor = [UIColor clearColor];
            name.textColor = [UIColor whiteColor];
            name.text = @"Hello Amap!";
            [self.calloutView addSubview:name];
        }
        
        [self addSubview:self.calloutView];
    }
    else
    {
        [self.calloutView removeFromSuperview];
    }
    
    [super setSelected:selected animated:animated];
}

- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event
{
    BOOL inside = [super pointInside:point withEvent:event];
    /* Points that lie outside the receiver’s bounds are never reported as hits,
     even if they actually lie within one of the receiver’s subviews.
     This can occur if the current view’s clipsToBounds property is set to NO and the affected subview extends beyond the view’s bounds.
     */
    if (!inside && self.selected)
    {
        inside = [self.calloutView pointInside:[self convertPoint:point toView:self.calloutView] withEvent:event];
    }
    
    return inside;
}

#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, kWidth, kHeight);
        
        self.backgroundColor = [UIColor grayColor];
        
        /* Create portrait image view and add to view hierarchy. */
        self.portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(kHoriMargin, kVertMargin, kPortraitWidth, kPortraitHeight)];
        [self addSubview:self.portraitImageView];
        
        /* Create name label. */
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPortraitWidth + kHoriMargin,
                                                                   kVertMargin,
                                                                   kWidth - kPortraitWidth - kHoriMargin,
                                                                   kHeight - 2 * kVertMargin)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor whiteColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:15.f];
//        [self addSubview:self.nameLabel];
    }
    
    return self;
}

@end



@implementation ProvinceAnnotationView


#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override


- (void)setModelDictionry:(NSDictionary *)modelDictionry {
    _modelDictionry= modelDictionry;
//    _nameLabel.text = [[modelDictionry valueForKey:@"merchantCount"] stringValue];
//    _nameLabel.text =  @"我是中国人";
//    int temp = [[modelDictionry valueForKey:@"merchantCount"] intValue];
//    self.itemCount = [NSNumber numberWithInt:temp];
    
    
    self.nameLabel.text = @"新疆维吾尔自治区";
    self.countLabel.text = @"经销商:50家";
    
}

- (void)setItemCount:(NSNumber *)itemCount{
//    _itemCount = itemCount;
//    self.nameLabel.text = self.itemCount.stringValue;
//    int fix = (int)(itemCount.intValue / 50) ;
//    if(fix > 20) {fix = 40;}
//    self.bounds = CGRectMake(0.f, 0.f, 50 + fix, 50 + fix);
//    self.nameLabel.frame = CGRectMake(  0,10,50 + fix,50 + fix - 20);
//    self.layer.cornerRadius = (50 + fix) / 2;
//    self.alpha = 0.6 + fix * 0.02;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }

    [super setSelected:selected animated:animated];
}



#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        self.backgroundColor = [UIColor systemTealColor];
        self.alpha = 0.6;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(  0,
                                                                   10,
                                                                   100,
                                                                   30)];
        
        self.nameLabel.backgroundColor  = [UIColor redColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor blackColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:12.f];
        self.nameLabel.text = self.itemCount.stringValue;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        self.layer.cornerRadius = 25;
        
        self.countLabel = [[UILabel alloc] initWithFrame:CGRectMake(  0,
                                                                   40,
                                                                   50,
                                                                   30)];
        
        self.countLabel.backgroundColor  = [UIColor cyanColor];
        self.countLabel.textAlignment    = NSTextAlignmentCenter;
        self.countLabel.textColor        = [UIColor blackColor];
        self.countLabel.font             = [UIFont systemFontOfSize:12.f];
        self.countLabel.text = self.itemCount.stringValue;
        self.countLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.countLabel];
        self.layer.cornerRadius = 25;
        
    }
    
    return self;
}

@end



@implementation CityAnnotationView


#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override


- (void)setModelDictionry:(NSDictionary *)modelDictionry {
    _modelDictionry= modelDictionry;
//    _nameLabel.text = [[modelDictionry valueForKey:@"merchantCount"] stringValue];
//    _nameLabel.text =  @"我是中国人";
    int temp = [[modelDictionry valueForKey:@"merchantCount"] intValue];
    self.itemCount = [NSNumber numberWithInt:temp];
}

- (void)setItemCount:(NSNumber *)itemCount{
    _itemCount = itemCount;
    self.nameLabel.text = self.itemCount.stringValue;
    int fix = (int)(itemCount.intValue / 50) ;
    if(fix > 20) {fix = 40;}
    self.bounds = CGRectMake(0.f, 0.f, 50 + fix, 50 + fix);
    self.nameLabel.frame = CGRectMake(  0,10,50 + fix,50 + fix - 20);
    self.layer.cornerRadius = (50 + fix) / 2;
    self.alpha = 0.6 + fix * 0.02;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }

    [super setSelected:selected animated:animated];
}



#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        self.backgroundColor = [UIColor systemYellowColor];
        self.alpha = 0.6;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(  0,
                                                                   10,
                                                                   50,
                                                                   30)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor blackColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:12.f];
        self.nameLabel.text = self.itemCount.stringValue;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        self.layer.cornerRadius = 25;
        
    }
    
    return self;
}

@end



@implementation MerchantAnnotationView


#pragma mark - Handle Action

- (void)btnAction
{
    CLLocationCoordinate2D coorinate = [self.annotation coordinate];
    
    NSLog(@"coordinate = {%f, %f}", coorinate.latitude, coorinate.longitude);
}

#pragma mark - Override


- (void)setModelDictionry:(NSDictionary *)modelDictionry {
    _modelDictionry= modelDictionry;
//    _nameLabel.text = [[modelDictionry valueForKey:@"merchantCount"] stringValue];
//    _nameLabel.text =  @"我是中国人";
    // int temp = [[modelDictionry valueForKey:@"name"] intValue];
    // // self.itemCount = [NSNumber numberWithInt:temp];
    //  self.nameLabel.text = self.itemCount.stringValue;

        self.nameLabel.text = [modelDictionry valueForKey:@"name"];

}

- (void)setItemCount:(NSNumber *)itemCount{
    _itemCount = itemCount;
    self.nameLabel.text = self.itemCount.stringValue;
    int fix = (int)(itemCount.intValue / 50) ;
    if(fix > 20) {fix = 40;}
    self.bounds = CGRectMake(0.f, 0.f, 50 + fix, 50 + fix);
    self.nameLabel.frame = CGRectMake(  0,10,50 + fix,50 + fix - 20);
    self.layer.cornerRadius = (50 + fix) / 2;
    self.alpha = 0.6 + fix * 0.02;
}

- (void)setSelected:(BOOL)selected
{
    [self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (self.selected == selected)
    {
        return;
    }

    [super setSelected:selected animated:animated];
}



#pragma mark - Life Cycle

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    
    if (self)
    {
        self.bounds = CGRectMake(0.f, 0.f, 50, 50);
        self.backgroundColor = [UIColor systemBrownColor];
        self.alpha = 0.6;
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(  0,
                                                                   10,
                                                                   50,
                                                                   30)];
        self.nameLabel.backgroundColor  = [UIColor clearColor];
        self.nameLabel.textAlignment    = NSTextAlignmentCenter;
        self.nameLabel.textColor        = [UIColor blackColor];
        self.nameLabel.font             = [UIFont systemFontOfSize:12.f];
        self.nameLabel.text = self.itemCount.stringValue;
        self.nameLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.nameLabel];
        self.layer.cornerRadius = 25;
        
    }
    
    return self;
}

@end
