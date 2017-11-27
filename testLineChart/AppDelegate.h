//
//  AppDelegate.h
//  testLineChart
//
//  Created by fx on 2017/11/22.
//  Copyright © 2017年 fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;


@end


 



/*
 
 
 
 http://www.jianshu.com/p/067825bb104f
 本想画一条折线，无奈 知识储备不够（本来想 分小块 独立开来  ）
 
 
 
 

 一  画坐标轴
 
 
 
 我看的 demo 是在 drawRect 方法 使用 UIGraphicsGetCurrentContext 进行绘制线条
 

 
 CGContextRef context = UIGraphicsGetCurrentContext();
 
 CGContextSetLineWidth(context, 2.0);
 CGContextSetRGBStrokeColor(context, 1, 0, 0, 1);//0 - 1  线条颜色
 
 CGContextMoveToPoint(context, bounceX, bounceY);
 CGContextAddLineToPoint(context, bounceX, rect.size.height - bounceY);// 直线
 CGContextAddLineToPoint(context,rect.size.width -  bounceX, rect.size.height - bounceY);
 CGContextStrokePath(context);
 
 * (bounceX, bounceY)  起点的中心点，受线条宽度影响
 
 
 
 想起 贝塞尔 也能画线条，在 drawRect 尝试
 
 UIBezierPath *bpath = [[UIBezierPath alloc] init];
 bpath.lineWidth = 2.0f;
 //    bpath.lineCapStyle = kCGLineCapRound;//线条端点样式
 //    bpath.lineJoinStyle = kCGLineJoinRound;//线条连接点样式
 [bpath moveToPoint:CGPointMake(left, top)];
 [bpath addLineToPoint:CGPointMake(left, self.height - bottom)];
 [bpath addLineToPoint:CGPointMake(self.width - right, self.height - bottom)];
 [[UIColor redColor] set];
 CGFloat dash[] = {0,0};
 [bpath setLineDash:dash count:1 phase:0];//设置虚线间隔
 //    [bpath closePath];//将路径闭合，即起点和终点连起
 [bpath stroke];//or fill
 
 //removeAllPoints
 
 
 
 
 work! 而 在 viewDidLoad 中并不 work。那么，UIBezierPath 只能使用在 drawRect？
 
 当然不是，UIBezierPath 可作为 CAShapeLayer 路径显示，不过 只为路径，线条样式取自 CAShapeLayer 相应属性
 UIBezierPath *path = [UIBezierPath bezierPath];
 [path moveToPoint: CGPointMake()];
 [path addLineToPoint: CGPointMake()];
 
 
 CAShapeLayer *shapel = [CAShapeLayer layer];
 shapel.frame = CGRectMake();
 shapel.backgroundColor = [UIColor blackColor].CGColor;
 
 shapel.lineWidth = 10.0;
 shapel.strokeColor = [UIColor whiteColor].CGColor;
 
 //设置虚线 也是 layer
 shapel.lineDashPattern=@[@(1), @(1.2)];
 
 shapel.path =path.CGPath;
 [self.view.layer addSublayer:shapel];
 
 
 
 * drawRect 中  UIBezierPath 坐标参照 UIView， 作为 CAShapeLayer 路径，坐标参照 CAShapeLayer
 
 
 
 
 
 
 
 
 二  渐变色   CAGradientLayer
 
 CAGradientLayer *gradientLayer = [CAGradientLayer new];
 gradientLayer.frame = CGRectMake();
 
 // 设置阶梯图层的背景
 //gradientLayer.backgroundColor = UIColor.grayColor().CGColor;
 
 // 图层的颜色空间(依据数组的顺序显示渐进色)
 gradientLayer.colors = @[ (__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor blueColor].CGColor,(__bridge id)[UIColor greenColor].CGColor] ;
 // 各区间百分比
 gradientLayer.locations = @[@(0.3),@(0.6),@(1.0)];
 
 
 
 //从 起点 到终点 是一条线段，渐变线方向   线段上的颜色 依据 colors 数组排布，先是  redColor 然后 blueColor 最后  greenColor。三种主色调 占据 的区域呢？ 对应  locations

 gradientLayer.startPoint = CGPointMake(1, 0);//右下角
 gradientLayer.endPoint = CGPointMake(0, 1);//左上角
 
 [self.view.layer addSublayer:gradientLayer];
 

 
 
 command  locations  ~> animatable
 layer 的大多属性 都标注 animatable，改变其值会有隐式动画效果
 
 

 
 
 
 三 动画
 
 
 
 
 UIBezierPath *path = [UIBezierPath bezierPath];
 [path moveToPoint: CGPointMake()];
 [path addLineToPoint: CGPointMake()];
 
 CAShapeLayer *shapel = [CAShapeLayer layer];
 shapel.backgroundColor = [UIColor blackColor].CGColor;
 shapel.frame = CGRectMake();
 shapel.lineWidth = 10.0;
 shapel.strokeColor = [UIColor whiteColor].CGColor;
 
 shapel.path =path.CGPath;
 
 //shapel.strokeStart = 0;
 //shapel.strokeEnd = 1;
 [self.view.layer addSublayer:shapel];
 
 
 
 CABasicAnimation *ba = [CABasicAnimation animationWithKeyPath:@"strokeEnd"];
 ba.fromValue = @(0);
 ba.toValue  = @(1);
 ba.duration = 2.f;
 //ba.autoreverses = YES;// 逆
 ba.removedOnCompletion = YES;
 //ba.fillMode = kCAFillModeForwards;//& ba.removedOnCompletion = NO  layer会保持着动画最后的状态
 ba.delegate = self; // eg ~> animationDidStop: finished:
 [shapel addAnimation:ba forKey:nil];
 
 
 
 *以 strokeEnd 属性 做动画，shapel.strokeEnd 更像是 动画移除之后的值
 

 
 
 
 
 
 
 如layer 存在多个 CABasicAnimation 则 组合
 CAAnimationGroup *groupA = [CAAnimationGroup animation];
 groupA.duration = 2.f;
 groupA.animations = @[];
 
 
 addAnimation:groupAnnimation
 
 
 
 
 
 
 
 
 CAKeyframeAnimation 关键帧动画  如小球的运动轨迹
 
 values = @[[NSValue valueWithCGPoint: ], ]  // 子路径集合
 keyTimes = @[[NSNumber numberWithFloat: ], ]  //各路径动画时间
 timeFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut], ]
 // 各路径运动节奏
 
 
 values 与 path是互斥的，当values与path同时指定时，path会覆盖values
 
 CGPathRef ~> CAKeyframeAnimation.path
 
 CGMutablePathRef path = CGPathCreateMutable();
 CGPathMoveToPoint
 CGPathAddLineToPoint
 CGPathRelease(path);
 
 
 UIBezierPath.CGPath
 
 
 
 

 
 
 
 

 
 
 
 四
 CATransition  一些好看的转场效果 是 私有api
 http://www.jianshu.com/p/39c051cfe7dd
 
 
 
 */




/*

 
 之所以 坐标轴 在 drawrect 方法  因为 坐标轴 是始终存在的  画的是 折线
 
 

 以 总高度为例
 
 假如 0 - 600 数值， 对应 高度 100点  然后 按比例 就可以
 

 
 
 
 
 
 
 
 
 
 
 
 
 
 
 
 

 
 */













