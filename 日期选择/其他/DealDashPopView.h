//
//  DealDashPopView.h
//  BeiLu
//
//  Created by YKJ2 on 16/6/28.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^YesBlock)();
typedef void(^NoBlock)();

@interface DealDashPopView : UIView
@property (weak, nonatomic) IBOutlet UIButton *yesBtn;
@property (weak, nonatomic) IBOutlet UIButton *noBtn;

@property (copy, nonatomic) YesBlock yesBlock;
@property (copy, nonatomic) NoBlock noBlock;

- (void)showPopView;
- (void)hidePopView;

@end
