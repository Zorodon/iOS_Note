//
//  ZXZAdvertView.m
//  BeiLu
//
//  Created by YKJ2 on 16/6/22.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "ZXZAdvertView.h"
#import "AdPageControl.h"

@interface ZXZAdvertView()<UIScrollViewDelegate>
@property (strong, nonatomic) UIScrollView *adScrollView;
@property (strong, nonatomic) AdPageControl *adPageControl;
@property (strong, nonatomic) UIImageView *leftImageView;
@property (strong, nonatomic) UIImageView *centerImageView;
@property (strong, nonatomic) UIImageView *rightImageView;
@property (strong, nonatomic) NSTimer *timer;
@property (strong, nonatomic) NSArray *imagesArr;
@property (assign, nonatomic) NSInteger currentImageIndex;
@property (assign, nonatomic) NSInteger imagesCount;
@property (assign, nonatomic) CGFloat viewWidth;
@property (assign, nonatomic) CGFloat viewHeight;

@end
@implementation ZXZAdvertView

- (instancetype)initWithFrame:(CGRect )rect images:(NSArray *)images{
    self = [super initWithFrame:rect];
    if (self) {
        self.imagesArr = [NSArray arrayWithArray:images];
        self.imagesCount = images.count;
        self.viewHeight = self.bounds.size.height;
        self.viewWidth = self.bounds.size.width;
        
        [self addSubview:self.adScrollView];
        [self addSubview:[self maskAdvertView]];
        [self addImageViews:images];
      
        if (self.imagesCount > 1){
            [self addSubview:self.adPageControl];
            [self addAdTimer];
        }
    }
    return self;
}

- (UIImageView *)maskAdvertView{
    UIImageView *maskView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.viewHeight/3*2, self.viewWidth, self.viewHeight/3)];
    [maskView setImage:[UIImage imageNamed:@"carouselmask"]];
    return maskView;
}

- (UIScrollView *)adScrollView {
    if (!_adScrollView) {
        _adScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        _adScrollView.bounces = YES;
        _adScrollView.pagingEnabled = YES;
        _adScrollView.delegate = self;
        _adScrollView.showsHorizontalScrollIndicator = NO;
        _adScrollView.showsVerticalScrollIndicator = NO;
        _adScrollView.contentSize = CGSizeMake(3*_viewWidth, _viewHeight);
        [_adScrollView setContentOffset:CGPointMake(_viewWidth, 0)];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
        [_adScrollView addGestureRecognizer:tap];
        
    }
    return _adScrollView;
}

- (UIPageControl *)adPageControl {
    if (!_adPageControl) {
        _adPageControl = [[AdPageControl alloc] initWithFrame:CGRectMake(_viewWidth/2,_viewHeight-25, 0, 10)];
        [_adPageControl setCurrentPageIndicatorTintColor:[UIColor whiteColor]];
        [_adPageControl setPageIndicatorTintColor:[UIColor lightGrayColor]];
        _adPageControl.numberOfPages = _imagesCount;
        _adPageControl.currentPage = 0;
    }
    return _adPageControl;
}

- (void)addImageViews:(NSArray *)images {

    if (self.imagesCount > 1){
        self.leftImageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.viewWidth, self.viewHeight)];
        self.leftImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        __block UIActivityIndicatorView *activityIndicator;
        
        [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:[images lastObject] size:self.leftImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        
            if (!activityIndicator)
            {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self.leftImageView addSubview:activityIndicator];
                activityIndicator.center = CGPointMake(self.leftImageView.frame.size.width/2, self.leftImageView.frame.size.height/2);
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
     
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            
            if (error) {
                self.leftImageView.image = [UIImage imageNamed:@"photofail"];
            }
            
        }];
        
        
        [self.adScrollView addSubview:self.leftImageView];
        
        self.centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
        self.centerImageView.contentMode=UIViewContentModeScaleAspectFit;
        
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:images[0] size:self.centerImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self.centerImageView addSubview:activityIndicator];
                activityIndicator.center = CGPointMake(self.centerImageView.frame.size.width/2, self.centerImageView.frame.size.height/2);
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            [activityIndicator removeFromSuperview];
            activityIndicator = nil;

            if (error) {
                self.centerImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
        
        
        [self.adScrollView addSubview:self.centerImageView];
        
        self.rightImageView=[[UIImageView alloc]initWithFrame:CGRectMake(2*self.viewWidth, 0, self.viewWidth, self.viewHeight)];
        self.rightImageView.contentMode=UIViewContentModeScaleAspectFit;

        [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:images[1] size:self.rightImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self.rightImageView addSubview:activityIndicator];
                activityIndicator.center = CGPointMake(self.rightImageView.frame.size.width/2, self.rightImageView.frame.size.height/2);
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {

            [activityIndicator removeFromSuperview];
            activityIndicator = nil;

            if (error) {
                self.rightImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
        
        
        
        
        
        [self.adScrollView addSubview:self.rightImageView];
    }else {
        
        self.centerImageView=[[UIImageView alloc]initWithFrame:CGRectMake(self.viewWidth, 0, self.viewWidth, self.viewHeight)];
        self.centerImageView.contentMode=UIViewContentModeScaleAspectFit;

        __block UIActivityIndicatorView *activityIndicator;
        [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:images[0] size:self.centerImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
            if (!activityIndicator)
            {
                activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [self.centerImageView addSubview:activityIndicator];
                activityIndicator.center = CGPointMake(self.centerImageView.frame.size.width/2, self.centerImageView.frame.size.height/2);
                [activityIndicator startAnimating];
            }
        } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
         
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            
            if (error) {
                self.centerImageView.image = [UIImage imageNamed:@"photofail"];
            }
        }];
        
        [self.adScrollView addSubview:self.centerImageView];
        
    }
    
    
}

- (void)addAdTimer
{
    if (self.timer == nil) {
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(runTimePage) userInfo:nil repeats:YES];
        [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
        self.timer = timer;
    }
}

- (void)removeAdTimer
{
    [self.timer invalidate];
    self.timer =nil;
}

- (void)runTimePage {
    self.currentImageIndex = (self.currentImageIndex+1)%self.imagesCount;
    
//    self.centerImageView.image = [UIImage imageNamed:self.imagesArr[self.currentImageIndex]];
    
    __block UIActivityIndicatorView *activityIndicator;
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[self.currentImageIndex] size:self.centerImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.centerImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.centerImageView.frame.size.width/2, self.centerImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.centerImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
    
    NSInteger leftImageIndex,rightImageIndex;
    leftImageIndex=(self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    rightImageIndex=(self.currentImageIndex+1)%self.imagesCount;
    
    self.leftImageView.image=[UIImage imageNamed:self.imagesArr[leftImageIndex]];
    
//    __block UIActivityIndicatorView *activityIndicator;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[leftImageIndex] size:self.leftImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.leftImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.leftImageView.frame.size.width/2, self.leftImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.leftImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
    
//    self.rightImageView.image=[UIImage imageNamed:self.imagesArr[rightImageIndex]];
    
    //        __block UIActivityIndicatorView *activityIndicator;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[rightImageIndex] size:self.rightImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.rightImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.rightImageView.frame.size.width/2, self.rightImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.rightImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
    
    [self.adScrollView setContentOffset:CGPointMake(self.viewWidth, 0)];
    self.adPageControl.currentPage = self.currentImageIndex;
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGPoint offset = scrollView.contentOffset;
    if (offset.x>self.viewWidth) {
        self.currentImageIndex = (self.currentImageIndex+1)%self.imagesCount;
    }else if(offset.x<self.viewWidth){
        self.currentImageIndex = (self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    }
//    self.centerImageView.image = [UIImage imageNamed:self.imagesArr[self.currentImageIndex]];
    
    __block UIActivityIndicatorView *activityIndicator;
    [self.centerImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[self.currentImageIndex] size:self.centerImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.centerImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.centerImageView.frame.size.width/2, self.centerImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.centerImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
    
    
    //重新设置左右图片
    NSInteger leftImageIndex,rightImageIndex;
    leftImageIndex=(self.currentImageIndex+self.imagesCount-1)%self.imagesCount;
    rightImageIndex=(self.currentImageIndex+1)%self.imagesCount;
//    self.leftImageView.image=[UIImage imageNamed:self.imagesArr[leftImageIndex]];
    
    //    __block UIActivityIndicatorView *activityIndicator;
    [self.leftImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[leftImageIndex] size:self.leftImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.leftImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.leftImageView.frame.size.width/2, self.leftImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.leftImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
//    self.rightImageView.image=[UIImage imageNamed:self.imagesArr[rightImageIndex]];
    
    //        __block UIActivityIndicatorView *activityIndicator;
    [self.rightImageView sd_setImageWithURL:[NSURL URLWithString:self.imagesArr[rightImageIndex] size:self.rightImageView.frame.size] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [self.rightImageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(self.rightImageView.frame.size.width/2, self.rightImageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (image) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
        }
        if (error) {
            [activityIndicator removeFromSuperview];
            activityIndicator = nil;
            self.rightImageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
    
    
    [self.adScrollView setContentOffset:CGPointMake(self.viewWidth, 0)];
    self.adPageControl.currentPage = self.currentImageIndex;
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    if (self.imagesCount > 1){
        [self removeAdTimer];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (self.imagesCount > 1){
        [self addAdTimer];
    }
}

- (void)tapAction {
    if (self.clickBlock) {
        self.clickBlock(self.currentImageIndex);
    }
}

@end
