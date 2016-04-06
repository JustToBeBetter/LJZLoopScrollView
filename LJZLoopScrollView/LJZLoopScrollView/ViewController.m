//
//  ViewController.m
//  LJZLoopScrollView
//
//  Created by 李金柱 on 16/4/6.
//  Copyright © 2016年 likeme. All rights reserved.
//

#import "ViewController.h"
#import "LJZLoopView.h"

@interface ViewController ()<LJZLoopViewDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *images = @[@"http://zc.like-me.cn/Uploads/2016-01-21/56a07f4bb2a41.jpg",
                         @"http://zc.like-me.cn/Uploads/2015-12-30/5683a66ee8780.jpg",
                         @"http://zc.like-me.cn/Uploads/2015-12-30/5683b3e3d16fb.jpg",
                         @"http://zc.like-me.cn/Uploads/2015-12-30/5683617b0b864.jpg"];
    LJZLoopView *topView = [[LJZLoopView alloc]initWithFrame:CGRectMake(0, 0, 375, 300)];
    topView.imageArray = images;
    topView.delegate = self;
    [self.view addSubview:topView];
    
}
-(void)currentIndex:(NSInteger)index{
    NSLog(@"%ld",index);
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
