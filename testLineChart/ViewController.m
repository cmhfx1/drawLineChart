//
//  ViewController.m
//  testLineChart
//
//  Created by fx on 2017/11/22.
//  Copyright © 2017年 fx. All rights reserved.
//

#import "ViewController.h"
#import "ILILineChart.h"

@interface ViewController ()

@property (nonatomic,weak)ILILineChart *chart;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    ILILineChart *linec = [ILILineChart chartWithXData:@[@"一月",@"二月",@"三月",@"四月",@"五月",@"六月"] YData:@[@"100",@"200",@"300",@"400",@"500"]];
    linec.frame = CGRectMake(0, 100, self.view.bounds.size.width, 200);
        linec.backgroundColor = [UIColor whiteColor];
    self.chart = linec;
    [self.view addSubview:linec];

}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.chart drawLineWithData:@[@"122.2", @"222.2", @"32.5", @"156.6", @"444", @"220.5"]];
}

@end
