//
//  LoginView.m
//  beilu
//
//  Created by YKJ2 on 16/4/5.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import "LoginView.h"
@interface LoginView()

@end
@implementation LoginView
- (instancetype)init{
    NSArray *subviewArray = [[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil];
    id mainView = [subviewArray objectAtIndex:0];
    return mainView;
}

- (instancetype)initInMaskView {
    self = [[[NSBundle mainBundle] loadNibNamed:@"LoginView" owner:self options:nil]firstObject];
    if (self) {
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
        [self.backgroundView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.backgroundView);
            CGFloat width = kScreenSize.width*3/5>200?kScreenSize.width*3/5:200;
            make.width.mas_equalTo(width);
            CGFloat height = kScreenSize.height*3/7>240?kScreenSize.height*3/7:240;
            make.height.mas_equalTo(height);
        }];

    }
    return self;
}
- (void)awakeFromNib {
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1].CGColor;
    self.layer.cornerRadius = 3;
    
    [self.createBtn setTitle:ZDLocalizedString(@"CreateAccount", nil) forState:UIControlStateNormal];
    [self.signBtn setTitle:ZDLocalizedString(@"SignIn", nil) forState:UIControlStateNormal];
    [self.skipBtn setTitle:ZDLocalizedString(@"Skip", nil) forState:UIControlStateNormal];
    
    self.createBtn.backgroundColor = kViceColor;
    self.signBtn.backgroundColor = kViceColor;
}
#pragma mark -  点击事件block
- (IBAction)createAccountAction:(id)sender {
    if (self.createAccountBlock) {
        self.createAccountBlock();
    }
}
- (IBAction)signInAction:(id)sender {
    if (self.signInBlock) {
        self.signInBlock();
    }
}
- (IBAction)skipAction:(id)sender {
    if (self.skipBlock) {
        self.skipBlock();
    }
}

@end
