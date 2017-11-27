//
//  ILIChart.h
//  testLineChart
//
//  Created by fx on 2017/11/23.
//  Copyright © 2017年 fx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ILILineChart : UIView

@property(nonatomic,assign)CGFloat coordinateTop;
@property(nonatomic,assign)CGFloat coordinateLeft;
@property(nonatomic,assign)CGFloat coordinateBottom;
@property(nonatomic,assign)CGFloat coordinateRight;
@property(nonatomic,assign)CGFloat coordinateLineWidth;

+ (instancetype)chartWithXData:(NSArray *)xd YData:(NSArray *)yd;

/** 画折线  */
- (void)drawLineWithData:(NSArray *)dataArray;
/** 画柱形图  */
- (void)drawBarWithData:(NSArray *)dataArray;
- (void)change;


@end


