//
//  MBPromptView.h
//  BeiLu
//
//  Created by YKJ1 on 16/4/25.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

@interface MBPromptView:MBProgressHUD

+ (void)showLoading;
+ (void)hideLoading;

+ (void)showText:(NSString *)text;
+ (void)showLoadingView:(UIView *)view;
+ (void)hideLoadingView;
@end

