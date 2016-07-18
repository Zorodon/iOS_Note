//
//  FDSlideBar.h
//  BeiLu
//
//  Created by YKJ1 on 16/4/7.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^FDSlideBarItemSelectedCallback)(NSUInteger idx);

@interface FDSlideBar : UIView

// All the titles of FDSilderBar
@property (copy, nonatomic) NSArray *itemsTitle;

// All the item's text color of the normal state
@property (strong, nonatomic) UIColor *itemColor;

// The selected item's text color
@property (strong, nonatomic) UIColor *itemSelectedColor;

// The slider color
@property (strong, nonatomic) UIColor *sliderColor;

// background colot
@property (strong, nonatomic) UIColor *itemBackgroundColor;

// Add the callback deal when a slide bar item be selected
- (void)slideBarItemSelectedCallback:(FDSlideBarItemSelectedCallback)callback;

// Set the slide bar item at index to be selected
- (void)selectSlideBarItemAtIndex:(NSUInteger)index;

@end

