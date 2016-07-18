////
////  QuantityOptionView.m
////  BeiLu
////
////  Created by YKJ2 on 16/4/27.
////  Copyright © 2016年 YKJ1. All rights reserved.
////
//
//#import "QuantityOptionView.h"
//#import "ZXZPickerView.h"
//
//@interface QuantityOptionView()<ZXZPickerViewDelegate>
//@property (strong, nonatomic) UIView *backgroundView;
//@property (strong, nonatomic) UIView *operationView;
//@property (strong, nonatomic) NSArray *options;
//
//@end
//@implementation QuantityOptionView
//
//- (instancetype)initWithImage:(NSString *)imageUrl title:(NSString *)title options:(NSArray *)options index:(NSInteger)idx{
//    self = [super init];
//    if (self) {
//        self.options = options;
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
//        UIImageView *imageView = [[UIImageView alloc] init];
//        [imageView sd_setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"refresh0"]];
//
//        [self.operationView addSubview:imageView];
//        
//        UILabel *titleL = [[UILabel alloc] init];
//        titleL.font = [UIFont boldSystemFontOfSize:13];
//        titleL.text = title;
//        [self.operationView addSubview:titleL];
//        
//        self.optionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.optionBtn.layer.borderColor = UIColorWithRGBA(136, 136, 136, 1).CGColor;
//        self.optionBtn.layer.borderWidth = 0.5;
//        self.optionBtn.titleLabel.font = [UIFont systemFontOfSize:12];
//        self.optionBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
//        self.optionBtn.contentEdgeInsets = UIEdgeInsetsMake(0,10, 0, 0);
//        [self.optionBtn setTitle:options[idx] forState:UIControlStateNormal];
//        [self.optionBtn setTitleColor:UIColorWithRGBA(136, 136, 136, 1) forState:UIControlStateNormal];
//        [self.optionBtn addTarget:self action:@selector(optionAction) forControlEvents:UIControlEventTouchUpInside];
//        [self.operationView addSubview:self.optionBtn];
//        
//        UIImageView *arrowImageView = [[UIImageView alloc] init];
//        arrowImageView.image = [UIImage imageNamed:@"shape4"];
//        [self.operationView addSubview:arrowImageView];
//        
//        self.doneBtn = [UIButton buttonWithType:UIButtonTypeSystem];
//        self.doneBtn.layer.cornerRadius = 3;
//        [self.doneBtn setTitle:ZDLocalizedString(@"Done", nil) forState:UIControlStateNormal];
//        [self.doneBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//        self.doneBtn.titleLabel.font = [UIFont boldSystemFontOfSize:13];
//        [self.doneBtn setBackgroundColor:kViceColor];
//        [self.operationView addSubview:self.doneBtn];
//        
//        self.cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//        self.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        [self.cancelBtn setTitleColor:UIColorWithRGBA(136, 136, 136, 1) forState:UIControlStateNormal];
//        [self.cancelBtn setUnderLineString:ZDLocalizedString(@"Cancel", nil)];
//        [self.operationView addSubview:self.cancelBtn];
//        
//        [self.operationView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.centerX.mas_equalTo(self.backgroundView.mas_centerX);
//            make.centerY.mas_equalTo(1000);
//            make.width.mas_equalTo(self.backgroundView.mas_width).multipliedBy(3/5.0);
//            make.height.mas_equalTo(self.backgroundView.mas_height).multipliedBy(3/7.0).priorityLow();
//        }];
//        
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(15);
//            make.centerX.mas_equalTo(self.operationView.mas_centerX);
//            make.size.mas_equalTo(CGSizeMake(80, 80));
//        }];
//        [titleL mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(imageView.mas_bottom).mas_offset(15);
//            make.centerX.mas_equalTo(self.operationView.mas_centerX);
//        }];
//        [self.optionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(titleL.mas_bottom).mas_offset(15);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.height.mas_equalTo(30);
//        }];
//        [arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.size.mas_equalTo(CGSizeMake(30, 30));
//            make.right.mas_equalTo(self.optionBtn.mas_right);
//            make.centerY.mas_equalTo(self.optionBtn.mas_centerY);
//        }];
//        [self.doneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.optionBtn.mas_bottom).mas_offset(10);
//            make.left.mas_equalTo(10);
//            make.right.mas_equalTo(-10);
//            make.height.mas_equalTo(40);
//        }];
//        
//        [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.doneBtn.mas_bottom).mas_equalTo(15);
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
//- (void)showQuantityView {
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
//- (void)hideQuantityView {
//    if (self.backgroundView) {
//        [UIView animateWithDuration:0.3 animations:^{
//            self.backgroundView.alpha = 0;
//        }completion:^(BOOL finished) {
//            [self.backgroundView removeFromSuperview];
//        }];
//    }
//}
//
//- (void)optionAction{
//    ZXZPickerView *optionPickerView = [[ZXZPickerView alloc] initWithContent:self.options];
//    optionPickerView.delegate = self;
//    [optionPickerView showPickerView];
//}
//
//#pragma mark - ZXZPickerViewDelegate
//- (void)pickerView:(ZXZPickerView *)pickerView didSelectRow:(NSInteger )row {
//    [pickerView hidePickerView];
//    [self.optionBtn setTitle:self.options[row] forState:UIControlStateNormal];
//}
//
//- (void)cancelSelectInZXZPickerView:(ZXZPickerView *)pickerView {
//    [pickerView hidePickerView];
//}
//@end
