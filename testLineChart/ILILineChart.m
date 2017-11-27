//
//  ILIChart.m
//  testLineChart
//
//  Created by fx on 2017/11/23.
//  Copyright © 2017年 fx. All rights reserved.
//

#import "ILILineChart.h"
#import "UIView+ILIExtension.h"

static CGFloat xLabelTopSpace = 2.f;
static CGFloat yLabelRightSpace = 2.f;

@interface ILILineChart()<CAAnimationDelegate>
@property (nonatomic,strong)NSMutableArray *xLabels;
@property (nonatomic,strong)NSMutableArray *yLabels;
@property (nonatomic,strong)NSMutableArray *dataLables;
@property (nonatomic,weak)UIBezierPath *path;
@property (nonatomic,weak)CAShapeLayer *slayer;
@property (nonatomic,assign)BOOL once;
@end

@implementation ILILineChart

+ (instancetype)chartWithXData:(NSArray *)xd YData:(NSArray *)yd
{
    ILILineChart *chart = [ILILineChart new];
    NSInteger i =0;
    for (id obj in xd) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)obj;
            [chart setupXYLabelString:string tag:1000+i X:YES];
            i++;
        }
    }
    i = 0;
    for (id obj in yd) {
        if ([obj isKindOfClass:[NSString class]]) {
            NSString *string = (NSString *)obj;
            [chart setupXYLabelString:string tag:2000+i X:NO];
            i++;
        }
    }
    return chart;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        
        _coordinateTop = 20;
        _coordinateLeft = 30;
        _coordinateBottom = 20;
        _coordinateRight = 20;
        _coordinateLineWidth = 2.f;
        _xLabels = [NSMutableArray array];
        _yLabels = [NSMutableArray array];
        _dataLables = [NSMutableArray array];
        _once = YES;
    }
    return self;
}

- (UILabel *)setupXYLabelString:(NSString *)string tag:(NSInteger)tag X:(BOOL)x;
{
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:12];
    label.tag = tag;
    label.text = string;
    [label sizeToFit];
    if (x) {
        label.textAlignment = NSTextAlignmentCenter;
        [self.xLabels addObject:label];
    }else{
        [self.yLabels addObject:label];
    }
    [self addSubview:label];
    return label;
}

- (void)drawRect:(CGRect)rect {
    
    CGFloat xheight = self.width - _coordinateLeft - _coordinateRight;
    CGFloat yheight = self.height - _coordinateTop - _coordinateBottom;
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.frame =CGRectMake(_coordinateLeft, _coordinateTop, xheight, yheight);
    gl.colors = @[(__bridge id)[UIColor colorWithRed:10/255.0 green:168/255.0 blue:30/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:120/255.0 green:168/255.0 blue:30/255.0 alpha:1.0].CGColor, (__bridge id)[UIColor colorWithRed:220/255.0 green:168/255.0 blue:30/255.0 alpha:1.0].CGColor];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.locations = @[@(0.4), @(0.7), @(1)];
    [self.layer addSublayer:gl];
    
    UIBezierPath *bpath = [UIBezierPath bezierPath];
    bpath.lineWidth = _coordinateLineWidth;
    [bpath moveToPoint:CGPointMake(_coordinateLeft, _coordinateTop)];;
    [bpath addLineToPoint:CGPointMake(_coordinateLeft, self.height - _coordinateBottom)];
    [bpath addLineToPoint:CGPointMake(self.width - _coordinateRight, self.height - _coordinateBottom)];
    [[UIColor blackColor] set];
    [bpath stroke];

    NSInteger count = self.yLabels.count;
    CGFloat y = yheight / count;
    for (int i = 1; i < count; i++) {
        UIBezierPath *line = [UIBezierPath bezierPath];
        [line moveToPoint:CGPointMake(_coordinateLeft, _coordinateTop + y*i)];
        [line addLineToPoint:CGPointMake(_coordinateLeft + xheight, _coordinateTop + y*i)];
        
        CAShapeLayer *sl = [CAShapeLayer layer];
        //   sl.frame = CGRectMake()
        sl.lineWidth = 1;
        sl.strokeColor = [UIColor whiteColor].CGColor;
        sl.path = line.CGPath;
        sl.lineDashPattern=@[@(1), @(1.2)];
        [self.layer addSublayer:sl];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger i =0;
    for (UILabel *la in self.xLabels) {
        NSInteger count = self.xLabels.count;
        CGFloat width =  (self.width - _coordinateLeft - _coordinateRight) *1.0  / count;
        la.x = _coordinateLeft + width * i;
        la.y = self.height - _coordinateBottom  +xLabelTopSpace;
        la.width = width;
        i++;
    }
    
    i = 0;
    for (UILabel *la in self.yLabels) {
        NSInteger count = self.yLabels.count;
        CGFloat width =  (self.height - _coordinateTop - _coordinateBottom) *1.0  / count;
        la.x = _coordinateLeft - la.width - yLabelRightSpace;
        la.y = _coordinateTop + (count - i - 1) * width;
        i++;
    }
}

- (void)drawLineWithData:(NSArray *)dataArray
{
    
    UIBezierPath *bp = [UIBezierPath bezierPath];
    NSInteger count = dataArray.count;
    
    CGFloat layerH = self.height - _coordinateTop - _coordinateBottom;
    for (int i = 0; i < count; i++) {
        
        NSString *string = dataArray[i];
        CGFloat num = [string floatValue];
        CGFloat max = [[(UILabel *)[self.yLabels lastObject] text] floatValue] ;
        CGFloat y = num * (self.height - _coordinateTop - _coordinateBottom) / max;
        CGFloat width = (self.width - _coordinateLeft - _coordinateRight) * 1.0 / self.xLabels.count;
        if (i == 0) {
            [bp moveToPoint:CGPointMake((0.5+i)*width, layerH -y)];
        }else{
            [bp addLineToPoint:CGPointMake((0.5+i)*width, layerH -y)];
        }
        
        UILabel *la = [[UILabel alloc] init];
        la.font = [UIFont systemFontOfSize:12];
        CGPoint layerP = CGPointMake((0.5+i)*width + _coordinateLeft, layerH -y +_coordinateTop);
        la.text = string;
        [la sizeToFit];
        la.origin = layerP;
        [self.dataLables addObject:la];
        [self addSubview:la];
    
    }
    self.path = bp;
    [self drawSetupLayerAnimalWithPath:bp];
}

- (void)drawBarWithData:(NSArray *)dataArray
{

    UIBezierPath *bp = [UIBezierPath bezierPath];
    NSInteger count = dataArray.count;
    self.path = bp;
    CGFloat xWidth = (self.width - _coordinateLeft - _coordinateRight) * 1.0 / self.xLabels.count;
    CGFloat layerH = self.height - _coordinateTop - _coordinateBottom;
    for (int i = 0; i < count; i++) {
        
        NSString *string = dataArray[i];
        CGFloat num = [string floatValue];
        CGFloat max = [[(UILabel *)[self.yLabels lastObject] text] floatValue] ;
        CGFloat y = num * (self.height - _coordinateTop - _coordinateBottom) / max;
        if (i == 0) {
            [bp moveToPoint:CGPointMake(0, self.height - _coordinateBottom - _coordinateTop)];
        }
        [bp addLineToPoint:CGPointMake(xWidth*i + xWidth/4.0, self.height - _coordinateBottom - _coordinateTop)];
        [bp addLineToPoint:CGPointMake(xWidth*i + xWidth/4.0, layerH -y)];
        [bp addLineToPoint:CGPointMake(xWidth*i + xWidth/4.0 + xWidth/2.0, layerH - y)];
        [bp addLineToPoint:CGPointMake(xWidth*i + xWidth/4.0 + xWidth/2.0, self.height - _coordinateBottom - _coordinateTop)];
    }
    [self drawSetupLayerAnimalWithPath:bp];
}

-(void)drawSetupLayerAnimalWithPath:(UIBezierPath *)path
{
    CAShapeLayer *layer = [CAShapeLayer layer];
    layer.frame = CGRectMake(_coordinateLeft, _coordinateTop, self.width - _coordinateLeft - _coordinateRight, self.height - _coordinateTop - _coordinateBottom);
    layer.lineWidth = 1.f;
    layer.strokeColor = [UIColor redColor].CGColor;
    layer.strokeEnd = 1.f;
    layer.path = path.CGPath;
    layer.fillColor = [[UIColor clearColor] CGColor];// fill?
    self.slayer = layer;
    [self.layer addSublayer:layer];
    
    CABasicAnimation *animal = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
    animal.duration = 3.f;
    animal.fromValue = @(0);
    animal.toValue = @(1);
    animal.removedOnCompletion = YES;
    animal.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];;
    animal.delegate = self;
    [layer addAnimation:animal forKey:nil];
}

- (void)change
{
    [self.path removeAllPoints];
    self.path = nil;
    [self.slayer removeFromSuperlayer];
    self.slayer = nil;
    [self.dataLables makeObjectsPerformSelector:@selector(removeFromSuperview)];
    [self.dataLables removeAllObjects];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    if (_once) {

            [self change];
            [self drawBarWithData:@[@"122.2", @"222.2", @"32.5", @"156.6", @"444", @"220.5"]];

        _once = NO;
    }else{
        self.slayer.fillColor = [[UIColor redColor] CGColor];
    }
    
}


@end
