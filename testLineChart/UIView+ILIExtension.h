//
//  UIView+ILIViewFrame.h
//  dddddd
//
//  Created by fx on 2017/9/13.
//  Copyright © 2017年 fx. All rights reserved.
//

/*
 定义的属性，在类目，并不会生成 实例变量， 只是 实现 setter 和 getter 方法
 */

#import <UIKit/UIKit.h>

@interface UIView (ILIViewFrame)


@property (nonatomic,assign)CGPoint origin;

@property (nonatomic,assign)CGSize size;

@property (nonatomic,assign)CGFloat x;
@property (nonatomic,assign)CGFloat y;
@property (nonatomic,assign)CGFloat width;
@property (nonatomic,assign)CGFloat height;

@property (nonatomic,assign)CGFloat centerX;
@property (nonatomic,assign)CGFloat centerY;

@end
