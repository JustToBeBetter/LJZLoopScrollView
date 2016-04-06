//
//  LJZLoopView.h
//  LJZLoopScrollView
//
//  Created by 李金柱 on 16/4/6.
//  Copyright © 2016年 likeme. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LJZLoopViewDelegate <NSObject>

- (void)currentIndex:(NSInteger)index;

@end

@interface LJZLoopView : UIView<UIScrollViewDelegate>

@property (nonatomic,assign) id<LJZLoopViewDelegate>  delegate;

@property (nonatomic,strong) NSArray  *imageArray;
@end
