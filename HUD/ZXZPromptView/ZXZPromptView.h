//
//  ZXZPromptView.h
//  BeiLu
//
//  Created by YKJ2 on 16/5/11.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZXZPromptView : UIView

+ (ZXZPromptView *)succeedWithDetail:(NSString *)detail;
+ (ZXZPromptView *)succeedWithDetail:(NSString *)detail duration:(CGFloat)duration;

+ (ZXZPromptView *)failWithDetail:(NSString *)detail;
+ (ZXZPromptView *)failWithDetail:(NSString *)detail duration:(CGFloat)duration;

+ (ZXZPromptView *)failWithTitle:(NSString *)title detail:(NSString *)detail;
+ (ZXZPromptView *)failWithTitle:(NSString *)title detail:(NSString *)detail duration:(CGFloat)duration;
@end
