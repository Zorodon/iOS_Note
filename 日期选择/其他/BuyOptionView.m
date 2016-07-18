////
////  BuyOptionView.m
////  BeiLu
////
////  Created by YKJ2 on 16/4/25.
////  Copyright © 2016年 YKJ1. All rights reserved.
////
//
//#import "BuyOptionView.h"
//
//@interface BuyOptionView()
//@property (strong, nonatomic) UIView *backgroundView;
//@property (strong, nonatomic) UIView *operationView;
//
//@end
//@implementation BuyOptionView
//
//- (instancetype)initWithImage:(NSString *)url optionTitles:(NSArray *)titles{
//    self = [super init];
//    if (self) {
//        self.optionBtnArr = [NSMutableArray array];
//        
//        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.8];
//        [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
//        
//        self.operationView = [[UIView alloc]init];
//        self.operationView.backgroundColor = [UIColor whiteColor];
//        self.operationView.layer.borderColor = UIColorWithRGBA(201, 201, 201, 1).CGColor;
//        self.operationView.layer.borderWidth = 1.5;
//        [self.backgroundView addSubview:self.operationView];
//        
//        self.imageView = [[UIImageView alloc] init];
//        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
//        [self.imageView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"refresh0"]];
//        [self.operationView addSubview:self.imageView];
//        
//        UIButton *lastBtn = nil;
//        for (int i=0; i<titles.count; i++) {
//            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
//            btn.layer.borderColor = UIColorWithRGBA(136, 136, 136, 1).CGColor;
//            btn.layer.borderWidth = 0.5;
//            btn.titleLabel.font = [UIFont systemFontOfSize:12];
//            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//            btn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//            [btn setTitle:titles[i] forState:UIControlStateNormal];
//            [btn setTitleColor:UIColorWithRGBA(136, 136, 136, 1) forState:UIControlStateNormal];
//            [self.operationView addSubview:btn];
//            [self.optionBtnArr addObject:btn];
//            
//            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.top.mas_equalTo(self.imageView.mas_bottom).mas_offset(15+i*40);
//                make.left.mas_equalTo(10);
//                make.right.mas_equalTo(-10);
//                make.height.mas_equalTo(30);
//            }];
//            if (i==titles.count-1) {
//                lastBtn = btn;
//            }
//            
//            UIImageView *imageView = [[UIImageView alloc] init];
//            imageView.image = [UIImage imageNamed:@"shape4"];
//            [self.operationView addSubview:imageView];
//            
//            [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//                make.size.mas_equalTo(CGSizeMake(30, 30));
//                make.right.mas_equalTo(btn.mas_right);
//                make.centerY.mas_equalTo(btn.mas_centerY);
//            }];
//        }
//        
//        self.buyBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        self.buyBtn.layer.cornerRadius = 3;
//        [self.buyBtn setTitle:ZDLocalizedString(@"Buy", nil) forState:UIControlStateNormal];
//        [self.buyBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.buyBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        [self.buyBtn setBackgroundColor:kViceColor];
//        [self.operationView addSubview:self.buyBtn];
//        
//        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.cancelBtn setTitleColor:UIColorWithRGBA(136, 136, 136, 1) forState:UIControlStateNormal];
//        [self.cancelBtn setUnderLineString:ZDLocalizedString(@"Cancel", nil)];
//        [self.operationView addSubview:self.cancelBtn];
//        
//        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.backgroundView.mas_centerX);
//            make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
//            make.width.mas_equalTo(self.backgroundView.mas_width).multipliedBy(3/5.0);
//            make.height.mas_equalTo(self.backgroundView.mas_height).multipliedBy(3/7.0).priorityLow();
//        }];
//        
//        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(15);
//            make.centerX.mas_equalTo(self.operationView.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(80, 80));
//        }];
//        
//        [self.buyBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(lastBtn.mas_bottom).mas_offset(10);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.height.mas_equalTo(40);
//        }];
//        
//        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.buyBtn.mas_bottom).mas_equalTo(15);
//            make.centerX.mas_equalTo(self.operationView.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(120, 20));
//        }];
//        
//        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.bottom.mas_equalTo(self.cancelBtn.mas_bottom).mas_offset(15).priorityHigh();
//        }];
//    }
//    return self;
//}
//
//- (void)showBuyView {
//    if (self.backgroundView) {
//        self.backgroundView.alpha = 0;
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundView.alpha = 1;
//        }];
//        
//        [self.operationView.superview layoutIfNeeded];
//        [UIView animateWithDuration:0.3 animations:^{
//            [self.operationView mas_updateConstraints:^(MASConstraintMaker *make) {
//                make.centerY.mas_equalTo(self.backgroundView.mas_centerY);
//            }];
//            [self.operationView.superview layoutIfNeeded];
//        }];
//    }
//}
//
//- (void)hideBuyView {
//    if (self.backgroundView) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundView.alpha = 0;
//        }completion:^(BOOL finished) {
//            [self.backgroundView removeFromSuperview];
//        }];
//    }
//}
//
//+ (UIImage *)createImageWithColor:(UIColor *)color
//{
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetFillColorWithColor(context, [color CGColor]);
//    CGContextFillRect(context, rect);
//    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
//    
//    return theImage;
//}
//
//@end
