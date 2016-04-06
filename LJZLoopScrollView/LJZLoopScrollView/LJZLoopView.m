
//
//  LJZLoopView.m
//  LJZLoopScrollView
//
//  Created by 李金柱 on 16/4/6.
//  Copyright © 2016年 likeme. All rights reserved.
//

#import "LJZLoopView.h"
#import "UIImageView+WebCache.h"

#define w self.frame.size.width
#define h self.frame.size.height

#define timerInterval  5.0

@implementation LJZLoopView
{
    UIScrollView *_ljzScrollView;
    UIPageControl *_ljzPageControl;
    NSMutableArray *_ljzDataArray;
    NSTimer  *_ljzTimer;
    BOOL   _ljzIsDraging;
    
    
    
}
- (void)dealloc{
    [self inValidateTimer];
}
- (void)inValidateTimer{
    if (_ljzTimer && [_ljzTimer isValid]) {
        [_ljzTimer invalidate];
        _ljzTimer = nil;
    }
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        _ljzIsDraging  = NO;
        _ljzScrollView = [[UIScrollView alloc]initWithFrame:self.frame];
        _ljzScrollView.scrollsToTop  = NO;
        _ljzScrollView.showsHorizontalScrollIndicator = NO;
        _ljzScrollView.delegate      = self;
        _ljzScrollView.pagingEnabled = YES;
        _ljzScrollView.contentInset = UIEdgeInsetsMake(0, w, 0, w);
        [self addSubview:_ljzScrollView];
        _ljzPageControl = [[UIPageControl alloc]initWithFrame:CGRectMake((w - 150)/2, h - 40, 150, 20)];
        [self addSubview:_ljzPageControl];
        
        
    }
    return self;
}
- (void)setImageArray:(NSArray *)imageArray{
    _imageArray = imageArray;
    if (_imageArray.count > 0) {
        _ljzPageControl.numberOfPages = _imageArray.count;
        [self addImageViewWithIndex:-1 imageIndex:(int)_imageArray.count-1];
        for (int i = 0; i < _imageArray.count; i++) {
            [self addImageViewWithIndex:i imageIndex:i];
        }
        
        [self addImageViewWithIndex:(int)_imageArray.count imageIndex:0];
    }
    _ljzScrollView.contentSize = CGSizeMake(_imageArray.count*w, 0);
    
    [self performSelector:@selector(timerStart) withObject:nil afterDelay:timerInterval];
}
- (void)addImageViewWithIndex:(int)i imageIndex:(int)imageIndex{
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(w*i, 0, w, h)];
    imageView.userInteractionEnabled = YES;
    [imageView sd_setImageWithURL:[NSURL URLWithString:_imageArray[imageIndex]]];
    imageView.tag = imageIndex;
    [_ljzScrollView addSubview:imageView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageViewTaped:)];
    [imageView addGestureRecognizer:tap];
}
- (void)imageViewTaped:(UITapGestureRecognizer *)gesture{
    if (self.delegate && [self.delegate respondsToSelector:@selector(currentIndex:)]) {
        [self.delegate currentIndex:gesture.view.tag];
    }
}
- (void)timerStart{
    [self inValidateTimer];
    _ljzTimer = [NSTimer scheduledTimerWithTimeInterval:timerInterval target:self selector:@selector(loopScroll) userInfo:nil repeats:YES];
    [_ljzTimer fire];
}
- (void)loopScroll{
    
    CGPoint contentOffset = _ljzScrollView.contentOffset;
    contentOffset.x += w;
    [UIView animateWithDuration:0.4 animations:^{
        _ljzScrollView.contentOffset = contentOffset;
        
    }completion:^(BOOL finished) {
        CGPoint newContentOffset = _ljzScrollView.contentOffset;
        int page = (int)newContentOffset.x/w;
        if (page == _imageArray.count) {
            newContentOffset.x = 0 ;
            _ljzScrollView.contentOffset = newContentOffset;
        }
        _ljzPageControl.currentPage = page % _imageArray.count;
        
    }];
}

#pragma
#pragma  mark =================scrollViewDelegate=================
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    if (_ljzIsDraging) {
        CGPoint contentOffset = scrollView.contentOffset;
        if (contentOffset.x == w*_imageArray.count) {
            _ljzPageControl.currentPage = 0;
            contentOffset.x = 0;
            scrollView.contentOffset = contentOffset;
        }else if (contentOffset.x == -w){
            _ljzPageControl.currentPage = _imageArray.count - 1;
            contentOffset.x = (_imageArray.count - 1)*w;
            scrollView.contentOffset = contentOffset;
        }else{
            _ljzPageControl.currentPage = (int)contentOffset.x/w;
        }
        
    }
}
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [_ljzTimer setFireDate:[NSDate distantFuture]];
    _ljzIsDraging = YES;
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [_ljzTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:timerInterval]];
    _ljzIsDraging = NO;
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
