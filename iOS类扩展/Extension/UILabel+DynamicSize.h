//
//  UILabel+DynamicSize.h
//  BeiLu
//
//  Created by YKJ2 on 16/4/18.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (DynamicSize)
-(CGFloat)expectedHeightWithWidth:(CGFloat)width;
-(CGFloat)expectedWidth;

@end
