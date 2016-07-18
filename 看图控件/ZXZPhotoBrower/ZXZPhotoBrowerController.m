//
//  ZXZPhotoBrowerController.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/21.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "ZXZPhotoBrowerController.h"
#import "UIImageView+WebCache.h"
#import "ZXZPhotoScrollView.h"


@interface ZXZPhotoBrowerController ()<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (strong, nonatomic) NSArray *photos;
@property (assign, nonatomic) NSInteger currentIndex;
@property (strong, nonatomic) NSMutableArray *imageViewArr;

@end

@implementation ZXZPhotoBrowerController

- (NSMutableArray *)imageViewArr {
    if (!_imageViewArr) {
        _imageViewArr = [NSMutableArray array];
    }
    return _imageViewArr;
}

- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)idx{
    self = [super init];
    if (self) {
        self.photos = photos;
        self.currentIndex = idx;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initPhotoScrollView];
    self.titleL.text = [NSString stringWithFormat:@"%ld / %lu",self.currentIndex+1,(unsigned long)self.photos.count];
}
- (void)initPhotoScrollView {
    
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(self.photos.count*kScreenWidth);
    }];
    for (int i=0; i<self.photos.count; i++) {
        ZXZPhotoScrollView *photoScrollView = [[ZXZPhotoScrollView alloc] initWithFrame:CGRectMake(i*kScreenWidth, 0, kScreenWidth, kScreenHeight-64)];
        [self.contentView addSubview:photoScrollView];
        [self.imageViewArr addObject:photoScrollView];
        
//        [photoScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(0);
//            make.left.mas_equalTo(i*kScreenWidth);
//            make.bottom.mas_equalTo(0);
//            make.width.mas_equalTo(kScreenWidth);
//        }];

    }
    [self startDownloadImageWithIndex:self.currentIndex];
    self.scrollView.contentSize = CGSizeMake(self.photos.count*kScreenWidth, self.contentView.frame.size.height);
    [self.scrollView setContentOffset:CGPointMake(self.currentIndex*kScreenWidth, 0) animated:YES];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)closeAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)startDownloadImageWithIndex:(NSInteger)idx {
    ZXZPhotoScrollView *photoScrollView = self.imageViewArr[idx];
    UIImageView *imageView = photoScrollView.imageView;
    __block UIActivityIndicatorView *activityIndicator;
    [imageView sd_setImageWithURL:[NSURL URLWithString:self.photos[idx]] placeholderImage:nil options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        if (!activityIndicator)
        {
            activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            [imageView addSubview:activityIndicator];
            activityIndicator.center = CGPointMake(imageView.frame.size.width/2, imageView.frame.size.height/2);
            [activityIndicator startAnimating];
        }
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        [activityIndicator removeFromSuperview];
        activityIndicator = nil;
        
        if (error) {
            imageView.image = [UIImage imageNamed:@"photofail"];
        }
    }];
}


#pragma mark - UIScrollView
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    NSInteger nextIndex = scrollView.contentOffset.x/kScreenWidth;
    if (nextIndex!=self.currentIndex) {
        [self startDownloadImageWithIndex:nextIndex];
        self.titleL.text =[NSString stringWithFormat:@"%ld / %lu",nextIndex+1,self.photos.count];
    }
    self.currentIndex = nextIndex;
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView {
    ZXZPhotoScrollView *photoScrollView = self.imageViewArr[self.currentIndex];
    [photoScrollView setZoomScale:1 animated:YES];

    
}
@end
