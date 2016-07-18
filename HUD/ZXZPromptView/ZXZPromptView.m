//
//  ZXZPromptView.m
//  BeiLu
//
//  Created by YKJ2 on 16/5/11.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#define kDuration 3.0

#import "ZXZPromptView.h"
@interface ZXZPromptView()
@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) NSTimer *endTimer;

@end
@implementation ZXZPromptView
+ (ZXZPromptView *)succeedWithDetail:(NSString *)detail {
    return [self initWithImage:[UIImage imageNamed:@"succeed"] title:nil detail:detail duration:kDuration];
}
+ (ZXZPromptView *)succeedWithDetail:(NSString *)detail duration:(CGFloat)duration{
    return [self initWithImage:[UIImage imageNamed:@"succeed"] title:nil detail:detail duration:duration];
}
+ (ZXZPromptView *)failWithDetail:(NSString *)detail {
    return [self initWithImage:[UIImage imageNamed:@"fail"] title:ZDLocalizedString(@"Oops", nil) detail:detail duration:kDuration];
}
+ (ZXZPromptView *)failWithDetail:(NSString *)detail duration:(CGFloat)duration {
    return [self initWithImage:[UIImage imageNamed:@"fail"] title:ZDLocalizedString(@"Oops", nil) detail:detail duration:duration];
}
+ (ZXZPromptView *)failWithTitle:(NSString *)title detail:(NSString *)detail {
    return [self initWithImage:[UIImage imageNamed:@"fail"] title:title detail:detail duration:kDuration];
}
+ (ZXZPromptView *)failWithTitle:(NSString *)title detail:(NSString *)detail duration:(CGFloat)duration{
    return [self initWithImage:[UIImage imageNamed:@"fail"] title:title detail:detail duration:duration];
}

+ (ZXZPromptView *)initWithImage:(UIImage *)image title:(NSString *)title detail:(NSString *)detail duration:(CGFloat)duration {
    ZXZPromptView *prompt = [[[NSBundle mainBundle] loadNibNamed:@"ZXZPromptView" owner:self options:nil] firstObject];
    if (prompt) {
        prompt.layer.borderWidth = 5;
        prompt.layer.borderColor = UIColorWithRGBA(99, 112, 116, 1).CGColor;
        prompt.layer.cornerRadius = 5;
        
        if (!title) {
            prompt.titleL.hidden = YES;
            [prompt.detailL mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(prompt.imageV.mas_bottom).mas_offset(10).priorityHigh();
            }];
        }else{
            prompt.titleL.text = [title isEqual:[NSNull null]]?@"":title;
        }
        prompt.imageV.image = image;
        prompt.detailL.text = [detail isEqual:[NSNull null]]?@"":detail;
        
        prompt.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        prompt.backgroundView.backgroundColor = [UIColor clearColor];
        [[UIApplication sharedApplication].keyWindow addSubview:prompt.backgroundView];
        [prompt.backgroundView addSubview:prompt];
        [prompt mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(prompt.backgroundView);
            make.width.mas_equalTo(kScreenWidth*2/3>250?kScreenWidth*2/3:250);
            make.height.mas_equalTo(kScreenWidth*2/5>150?kScreenWidth*2/5:150);
        }];
        
        if (prompt.endTimer == nil){
            prompt.endTimer = [NSTimer scheduledTimerWithTimeInterval:duration target:prompt selector:@selector(endTimerAction:) userInfo:prompt repeats:YES];
        }
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:prompt action:@selector(hideAction:)];
        prompt.backgroundView.userInteractionEnabled = YES;
        [prompt.backgroundView addGestureRecognizer:tap];
    }
    return prompt;
}

- (void)endTimerAction:(NSTimer *)sender {
    ZXZPromptView *prompt = sender.userInfo;
    if (prompt.backgroundView) {
        [UIView animateWithDuration:0.3 animations:^{
            prompt.backgroundView.transform=CGAffineTransformMakeScale(0.1, 0.1);
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [prompt.backgroundView removeFromSuperview];
        }];
    }
}
- (void)hideAction:(UIGestureRecognizer *)gesture {
    ZXZPromptView *prompt;
    for (UIView *view in gesture.view.subviews) {
        if ([view isKindOfClass:[ZXZPromptView class]]) {
            prompt = (ZXZPromptView *)view;
        }
    }
    if (prompt) {
        [prompt.endTimer invalidate];
        prompt.endTimer = nil;
        [UIView animateWithDuration:0.3 animations:^{
            prompt.backgroundView.transform=CGAffineTransformMakeScale(0.1, 0.1);
            self.backgroundView.alpha = 0;
        } completion:^(BOOL finished) {
            [prompt.backgroundView removeFromSuperview];
        }];
    }
}
@end
