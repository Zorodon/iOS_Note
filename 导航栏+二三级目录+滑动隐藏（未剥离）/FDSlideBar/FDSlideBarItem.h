//
//  FDSlideBarItem.h
//  BeiLu
//
//  Created by YKJ1 on 16/4/7.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FDSlideBarItemDelegate;

@interface FDSlideBarItem : UIView

@property (assign, nonatomic) BOOL selected;
@property (weak, nonatomic) id<FDSlideBarItemDelegate> delegate;

- (void)setItemTitle:(NSString *)title;
- (void)setItemTitleFont:(CGFloat)fontSize;
- (void)setItemTitleColor:(UIColor *)color;
- (void)setItemSelectedTileFont:(CGFloat)fontSize;
- (void)setItemSelectedTitleColor:(UIColor *)color;

+ (CGFloat)widthForTitle:(NSString *)title;

@end

@protocol FDSlideBarItemDelegate <NSObject>

- (void)slideBarItemSelected:(FDSlideBarItem *)item;

@end
