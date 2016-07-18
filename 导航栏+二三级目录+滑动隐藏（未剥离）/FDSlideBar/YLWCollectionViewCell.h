//
//  YLWCollectionViewCell.h
//  推库iOS
//
//  Created by Mac on 16/2/18.
//  Copyright © 2016年 YLW. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductsViewController.h"


typedef NS_ENUM(NSUInteger, CollectionViewCellType) {
    CollectionViewCellTypeHome,
    CollectionViewCellTypeCategory,
};

@interface YLWCollectionViewCell : UICollectionViewCell
@property (nonatomic,strong) ProductsViewController *productsViewController;
@property (nonatomic,assign) BOOL isDealDashPage;

- (void)setupCollectionViewType:(CollectionViewCellType )type;
@end
