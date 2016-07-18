//
//  LoginedView.m
//  BeiLu
//
//  Created by YKJ2 on 16/5/4.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "LoginedView.h"
@interface LoginedView()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UIButton *signInBtn;
@property (weak, nonatomic) IBOutlet UILabel *titleLPs;
@property (weak, nonatomic) IBOutlet UIButton *changeBtn;
@end
@implementation LoginedView

- (instancetype)initWithImage:(NSString *)imageUrl title:(NSString *)title {
    self = [[[NSBundle mainBundle] loadNibNamed:@"LoginedView" owner:self options:nil]firstObject];
    if (self) {

        [self.imageV sd_setImageWithURL:[NSURL URLWithString:imageUrl size:self.imageV.frame.size] placeholderImage:[UIImage imageNamed:@"gender"]];
        self.titleL.text = title;
        
        [self.signInBtn setTitle:ZDLocalizedString(@"SignIn", nil) forState:UIControlStateNormal];
        self.titleLPs.text = ZDLocalizedString(@"NotYou", nil);
        [self.changeBtn setUnderLineString:ZDLocalizedString(@"ChangeUser", nil)];
        
        self.signInBtn.backgroundColor = kViceColor;
    }
    return self;
    
}
- (void)awakeFromNib {
    self.layer.borderWidth = 1.5f;
    self.layer.borderColor = [UIColor colorWithWhite:0.9f alpha:1].CGColor;
    self.layer.cornerRadius = 3;
}
#pragma mark -  点击事件block
- (IBAction)signInAction:(id)sender {
    if (self.signInBlock) {
        self.signInBlock();
    }
}
- (IBAction)changeAction:(id)sender {
    if (self.changeBlock) {
        self.changeBlock();
    }
}

@end
