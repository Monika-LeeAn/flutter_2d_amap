//
//  ZYProvinceAnnotationView.m
//  flutter_2d_amap
//
//  Created by developer on 2022/3/1.
//

#import "ZYProvinceAnnotationView.h"

typedef void (^ActionBlock)();

static CGFloat const kJPSThumbnailAnnotationViewStandardWidth     = 65.0f;
static CGFloat const kJPSThumbnailAnnotationViewStandardHeight    = 87.0f;
static CGFloat const kJPSThumbnailAnnotationViewExpandOffset      = 200.0f;
static CGFloat const kJPSThumbnailAnnotationViewVerticalOffset    = 10.0f;
static CGFloat const kJPSThumbnailAnnotationViewAnimationDuration = 0.25f;

@interface ZYProvinceAnnotationView ()

@property (nonatomic, readwrite) CLLocationCoordinate2D coordinate;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *mainLabel;

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UIImageView *disclosureImageView;
//@property (nonatomic, strong) ActionBlock disclosureBlock;

@property (nonatomic, strong) CAShapeLayer *bgLayer;
@property (nonatomic, strong) UIButton *disclosureButton;
@property (nonatomic, assign) ZYProvinceAnnotationViewState state;

@end

@implementation ZYProvinceAnnotationView



#pragma mark - Override


- (void)setModelDictionry:(NSDictionary *)modelDictionry {
    _modelDictionry= modelDictionry;

//    self.mainLabel.text = @"12345";
//    self.titleLabel.text = @"asdas";
//    self.subtitleLabel.text =@"klajdklasjlk";
    
    self.mainLabel.text = [modelDictionry[@"merchantCount"] stringValue];
    self.titleLabel.text = modelDictionry[@"name"];
    self.subtitleLabel.text = [NSString stringWithFormat:@"该省份共有%@家经销商",modelDictionry[@"merchantCount"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    if (selected){
        _bgLayer.fillColor =[UIColor colorWithRed:239/255.0f green:131/255.0f blue:51/255.0f alpha:1.0f].CGColor;
        _mainLabel.textColor = [UIColor whiteColor];
    } else {
        _mainLabel.textColor =[UIColor colorWithRed:239/255.0f green:131/255.0f blue:51/255.0f alpha:1.0f];
        _bgLayer.fillColor = [UIColor whiteColor].CGColor;
    }
}

- (id)initWithAnnotation:(id<MAAnnotation>)annotation reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier];
    self.draggable = false;

    if (self) {
        self.canShowCallout = NO;
        self.frame = CGRectMake(0, 0, kJPSThumbnailAnnotationViewStandardWidth, 42);
        self.backgroundColor = [UIColor clearColor];
        self.centerOffset = CGPointMake(0, -kJPSThumbnailAnnotationViewVerticalOffset);

        _state = ZYProvinceAnnotationViewStateCollapsed;
        
        [self setupView];
        
    }
    
//    [self expand];
//    self.backgroundColor = [UIColor redColor];
//    self.alpha = 0.5;
    return self;
}

- (void)setupView {
    [self setupMainTextView];
    [self setLayerProperties];
    [self setDetailGroupAlpha:0.0f];
}

- (void)setupMainTextView {
    _mainLabel = [[UILabel alloc] initWithFrame:CGRectMake(5.5f, 6.5f, self.bounds.size.width - 11.0f, 25.0f)];
    _mainLabel.textColor = [UIColor colorWithRed:239/255.0f green:131/255.0f blue:51/255.0f alpha:1.0f];
    _mainLabel.font = [UIFont boldSystemFontOfSize:12];
    _mainLabel.minimumScaleFactor = 0.8f;
    _mainLabel.adjustsFontSizeToFitWidth = YES;
    _mainLabel.textAlignment = NSTextAlignmentCenter;
    _mainLabel.layer.cornerRadius = 4.0f;
    _mainLabel.layer.masksToBounds = YES;
    [self addSubview:_mainLabel];
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





#pragma mark - Geometry

- (CGPathRef)newBubbleWithRect:(CGRect)rect {
    CGFloat stroke = 1.0f;
    CGFloat radius = 4.0f;
    CGMutablePathRef path = CGPathCreateMutable();
    CGFloat parentX = rect.origin.x + rect.size.width/2.0f;
    
    // Determine Size
    rect.size.width -= stroke + 14.0f;
    rect.size.height -= stroke + 19.0f;
    rect.origin.x = rect.origin.x + (stroke / 2.0f + 7.0f);
    rect.origin.y = rect.origin.y + (stroke / 2.0f + 7.0f);
    
    // Create Callout Bubble Path
    
    //左上
    CGPathMoveToPoint(path, NULL, rect.origin.x, rect.origin.y + radius);
    //坐下
    CGPathAddLineToPoint(path, NULL, rect.origin.x, rect.origin.y + rect.size.height - radius);
    //左上到坐下的弧
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + rect.size.height - radius, radius, M_PI, M_PI_2, 1);
    
    
    //左边下潜的点
    CGPathAddLineToPoint(path, NULL, parentX - 7.0f, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, parentX, rect.origin.y + rect.size.height + 7.0f);
    CGPathAddLineToPoint(path, NULL, parentX + 7.0f, rect.origin.y + rect.size.height);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + rect.size.height - radius, radius, M_PI_2, 0.0f, 1.0f);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + rect.size.width, rect.origin.y + radius);
    CGPathAddArc(path, NULL, rect.origin.x + rect.size.width - radius, rect.origin.y + radius, radius, 0.0f, -M_PI_2, 1.0f);
    CGPathAddLineToPoint(path, NULL, rect.origin.x + radius, rect.origin.y);
    CGPathAddArc(path, NULL, rect.origin.x + radius, rect.origin.y + radius, radius, -M_PI_2, M_PI, 1.0f);
    CGPathCloseSubpath(path);
    return path;
}

#pragma mark - Animations

- (void)setDetailGroupAlpha:(CGFloat)alpha {
    self.disclosureButton.alpha = alpha;
    self.titleLabel.alpha = alpha;
    self.subtitleLabel.alpha = alpha;
    self.disclosureImageView.alpha = alpha;
}


@end


 
