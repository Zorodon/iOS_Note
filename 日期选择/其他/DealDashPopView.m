//
//  DealDashPopView.m
//  BeiLu
//
//  Created by YKJ2 on 16/6/28.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "DealDashPopView.h"
@interface DealDashPopView()
@property (strong, nonatomic) UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleL;

@end

@implementation DealDashPopView

- (instancetype)init{
    self = [[[NSBundle mainBundle] loadNibNamed:@"DealDashPopView" owner:self options:nil] firstObject];
    if (self) {
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
        [self.backgroundView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.backgroundView.mas_centerX);
            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
            make.width.mas_equalTo(0).priorityHigh();
            make.height.mas_equalTo(0).priorityHigh();
        }];
        
        [self.noBtn setTitle:ZDLocalizedString(@"No", nil) forState:UIControlStateNormal];
        [self.yesBtn setTitle:ZDLocalizedString(@"Yes", nil) forState:UIControlStateNormal];
        
        [self.noBtn addTarget:self action:@selector(noAction) forControlEvents:UIControlEventTouchUpInside];
        [self.yesBtn addTarget:self action:@selector(yesAction) forControlEvents:UIControlEventTouchUpInside];

        NSString *content = ZDLocalizedString(@"TxYGTOTSUNG", nil);
        self.titleL.attributedText = [content lineSpaceAttributedStringWithSpace:3];
        
    }
    return self;
}

- (void)showPopView {
    if (self.backgroundView) {
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1;
        }];
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(300).priorityHigh();
                make.height.mas_equalTo(200).priorityHigh();
            }];
            [self.superview layoutIfNeeded];
        }];

    }
}

- (void)hidePopView {
    if (self.backgroundView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0;
        }completion:^(BOOL finished) {
            [self.backgroundView removeFromSuperview];
        }];
    }
}

- (void)noAction {
    [self hidePopView];
    if (self.noBlock) {
        self.noBlock();
    }
}

- (void)yesAction {
    [self hidePopView];
    if (self.yesBlock) {
        self.yesBlock();
    }
}
@end
