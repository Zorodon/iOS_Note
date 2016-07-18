//
//  YLWCollectionViewCell.m
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import "YLWCollectionViewCell.h"
#import "HomeViewController.h"

@interface YLWCollectionViewCell()
@property (nonatomic,strong) HomeViewController *homeViewController;

@end
@implementation YLWCollectionViewCell

-(ProductsViewController *)productsViewController{
    if (_productsViewController == nil) {
        _productsViewController = [[ProductsViewController alloc]init];
    }
    return _productsViewController;
}

-(HomeViewController *)homeViewController{
    if (_homeViewController == nil) {
        _homeViewController = [[HomeViewController alloc]init];
    }
    return _homeViewController;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        
    }
    return self;
}

- (void)setupCollectionViewType:(CollectionViewCellType )type{
    if (type == CollectionViewCellTypeHome) {
        self.homeViewController.view.frame = self.bounds;
        [self.contentView addSubview:self.homeViewController.view];
    }else{
        self.productsViewController.collectionView.frame = self.bounds;
        [self.contentView addSubview:self.productsViewController.collectionView];
    }
}
- (void)setIsDealDashPage:(BOOL)isDealDashPage {
    self.productsViewController.isDealDashPage = isDealDashPage;
}

@end
