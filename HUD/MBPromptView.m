//
//  MBPromptView.m
//  BeiLu
//
//  Created by YKJ1 on 16/4/25.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MBPromptView.h"

@interface MBPromptView()

@end

@implementation MBPromptView

+ (void)showLoading {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeIndeterminate;
    hud.labelText = ZDLocalizedString(@"Loading", nil);
    hud.opaque = YES;
    hud.alpha = 0.7f;
    hud.minSize = CGSizeMake(120, 120);
}

+ (void)hideLoading {
    [MBProgressHUD hideHUDForView:[UIApplication sharedApplication].keyWindow animated:YES];
}
+ (void)showText:(NSString *)text {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:[UIApplication sharedApplication].keyWindow animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.labelText = text;
//    hud.opaque = YES;
//    hud.minSize = CGSizeMake(150, 150);
    [hud hide:YES afterDelay:1.2];
    
}

UIActivityIndicatorView *activity;
UILabel *titleL;


+ (void)showLoadingView:(UIView *)view {
   
    [activity removeFromSuperview];
    [titleL removeFromSuperview];
    
    activity = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(0, 0, 35, 35)];//指定进度轮的大小
    [activity setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleGray];//设置进度轮显示类型
    [view addSubview:activity];
    
    titleL = [[UILabel alloc]init];
    [view addSubview:titleL];
    
    [activity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(view.mas_centerY).mas_offset(-40);
        make.left.mas_equalTo(view.mas_centerX).mas_equalTo(-15);
    }];
    
    

    titleL.font = [UIFont boldSystemFontOfSize:12];
    titleL.textColor = bGroundColor;
    titleL.text = ZDLocalizedString(@"Loading", nil);
    
    [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(activity.mas_bottom).mas_equalTo(8);
        make.centerX.mas_equalTo(activity.mas_centerX);
    }];
    
    titleL.hidden = NO;
    
    [activity startAnimating];
}

+ (void)hideLoadingView{
    titleL.hidden = YES;
    [activity stopAnimating];
}



@end
