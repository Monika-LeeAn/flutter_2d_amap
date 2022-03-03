//
//  ZYMerchantAnnotationView.m
//  flutter_2d_amap
//
//  Created by developer on 2022/3/3.
//

#import "ZYMerchantAnnotationView.h"
static CGFloat const kJPSThumbnailAnnotationViewStandardWidth     = 75.0f;
static CGFloat const kJPSThumbnailAnnotationViewStandardHeight    = 87.0f;
static CGFloat const kJPSThumbnailAnnotationViewExpandOffset      = 200.0f;
static CGFloat const kJPSThumbnailAnnotationViewVerticalOffset    = 34.0f;
static CGFloat const kJPSThumbnailAnnotationViewAnimationDuration = 0.25f;
@interface ZYMerchantAnnotationView()


@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *mainLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *disclosureImageView;
//@property (nonatomic, strong) ActionBlock disclosureBlock;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *disclosureButton;



@end

@implementation ZYMerchantAnnotationView


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
    
    
//    self.nameLabel.text = @"新疆维吾尔自治区";
//    self.countLabel.text = @"经销商:50家";
//    [1]    (null)    @"merchantNum" : (int)45
//    [4]    (null)    @"provinceName" : @"江苏省"
//        self.coordinate = thumbnail.coordinate;
    self.mainLabel.text = [modelDictionry[@"merchantCount"] stringValue]; //@"12345";//
        self.titleLabel.text = modelDictionry[@"cityName"];
        self.subtitleLabel.text = [NSString stringWithFormat:@"该城市共有%@家经销商",modelDictionry[@"merchantCount"]];
//            self.titleLabel.text = @"asdas";
//            self.subtitleLabel.text =@"klajdklasjlk";
//        self.imageView.image = thumbnail.image;
//        self.disclosureBlock = thumbnail.disclosureBlock;
//        self.imageView.contentMode = thumbnail.contentMode;
    
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


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{

    if(selected){
        _bgLayer.fillColor = [UIColor systemGreenColor].CGColor;
    } else {
        _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    }
    
    if (!selected) {
        return;
    }
    
}



#pragma mark - Life Cycle


- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.draggable = false;

    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, kJPSThumbnailAnnotationViewStandardWidth, kJPSThumbnailAnnotationViewStandardHeight);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kJPSThumbnailAnnotationViewVerticalOffset);


//        [self addTarget:self action:@selector(clickSelfOnExpanded) forControlEvents:UIControlEventTouchUpInside];
        
//        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapEvent:)];
//        //将手势添加到需要相应的view中去
//        [self addGestureRecognizer:tapGesture];
//        //选择触发事件的方式（默认单机触发）
//
//        [tapGesture setNumberOfTapsRequired:1];
        
        [self setupView];
        
    }
    
//    [self expand];
    
    return self;
}

//- (void)tapEvent:(UITapGestureRecognizer *)gesture{
//
//    if(self.state == ZYCityAnnotationViewStateExpanded){
//        [self shrink];
//    } else if (self.state == ZYCityAnnotationViewStateCollapsed){
//        [self expand];
//    }
////    [self touch]
//}

- (void)setupView {
    [self setupImageView];
    [self setLayerProperties];
}

- (void)setupMainTextView {
    _mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(12.5f, 12.5f, 50.0f, 47.0f)];
    _mainLabel.textColor = [UIColor darkTextColor];
    _mainLabel.font = [UIFont boldSystemFontOfSize:20];
    _mainLabel.minimumScaleFactor = 0.8f;
    _mainLabel.adjustsFontSizeToFitWidth = YES;
    _mainLabel.textAlignment = NSTextAlignmentCenter;
    _mainLabel.layer.cornerRadius = 4.0f;
    _mainLabel.layer.masksToBounds = YES;
    _mainLabel.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _mainLabel.layer.borderWidth = 0.5f;
    _mainLabel.text = @"";
    [self addSubview:_mainLabel];
}

- (void)setupImageView {
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12.5f, 12.5f, 50.0f, 47.0f)];
    _imageView.layer.cornerRadius = 4.0f;
    _imageView.layer.masksToBounds = YES;
    _imageView.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    _imageView.layer.borderWidth = 0.5f;
    if (@available(iOS 13.0, *)) {
        _imageView.image = [UIImage systemImageNamed:@"mappin.and.ellipse"];
    } else {
        // Fallback on earlier versions
    }
    _imageView.contentMode = UIViewContentModeScaleAspectFill;
    [self addSubview:_imageView];
}

- (void)setupTitleLabel {
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32.0f, 16.0f, 168.0f, 20.0f)];
    _titleLabel.textColor = [UIColor darkTextColor];
    _titleLabel.font = [UIFont boldSystemFontOfSize:17];
    _titleLabel.minimumScaleFactor = 0.8f;
    _titleLabel.adjustsFontSizeToFitWidth = YES;
    [self addSubview:_titleLabel];
}

- (void)setupSubtitleLabel {
    _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(-32.0f, 36.0f, 168.0f, 20.0f)];
    _subtitleLabel.textColor = [UIColor grayColor];
    _subtitleLabel.font = [UIFont systemFontOfSize:12.0f];
    [self addSubview:_subtitleLabel];
}



- (void)setupDisclosureButton {
    BOOL iOS7 = [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f;
    UIButtonType buttonType = iOS7 ? UIButtonTypeSystem : UIButtonTypeCustom;
    _disclosureButton = [UIButton buttonWithType:buttonType];
    _disclosureButton.backgroundColor = [UIColor clearColor];
    _disclosureButton.tintColor = [UIColor grayColor];
    _disclosureButton.frame = CGRectMake(self.frame.origin.x - kJPSThumbnailAnnotationViewExpandOffset/2+10,
                                         self.frame.origin.y + 43,
                                         self.frame.size.width + kJPSThumbnailAnnotationViewExpandOffset-20,
                                         self.frame.size.height-33);
    
    [_disclosureButton addTarget:self action:@selector(didTapDisclosureButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_disclosureButton];
}

- (void)setLayerProperties {
    _bgLayer = [CAShapeLayer layer];
    CGPathRef path = [self newBubbleWithRect:self.bounds];
    _bgLayer.path = path;
    CFRelease(path);
    _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    
    _bgLayer.shadowColor = [UIColor blackColor].CGColor;
    _bgLayer.shadowOffset = CGSizeMake(0.0f, 3.0f);
    _bgLayer.shadowRadius = 2.0f;
    _bgLayer.shadowOpacity = 0.5f;
    
    _bgLayer.masksToBounds = NO;
    
    [self.layer insertSublayer:_bgLayer atIndex:0];
}
#pragma mark - Updating

//- (void)updateWithThumbnail:(JPSThumbnail *)thumbnail {
//    self.coordinate = thumbnail.coordinate;
//    self.titleLabel.text = thumbnail.title;
//    self.subtitleLabel.text = thumbnail.subtitle;
//    self.imageView.image = thumbnail.image;
//    self.disclosureBlock = thumbnail.disclosureBlock;
//    self.imageView.contentMode = thumbnail.contentMode;
//}

 
#pragma mark - Geometry

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0f;
    CGFloat radius = 7.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat parentX = rect.origin.x + rect.size.width/2.0f;
    
    // Determine Size
    rect.size.width -= stroke + 14.0f;
    rect.size.height -= stroke + 29.0f;
    rect.origin.x += stroke / 2.0f + 7.0f;
    rect.origin.y += stroke / 2.0f + 7.0f;
    
    // Create Callout Bubble Path
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
    CGPathAddLineToPoint(path, NULL, parentX - 14.0f, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 14.0f);
    CGPathAddLineToPoint(path, NULL, parentX + 14.0f, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
    CGPathCloseSubpath(path);
    return path;
}








@end
