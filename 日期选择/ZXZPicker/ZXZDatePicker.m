//
//  ZXZDatePicker.m
//  beilu
//
//  Created by YKJ2 on 16/4/6.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import "ZXZDatePicker.h"


@interface ZXZDatePicker()
@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;
@property (strong, nonatomic) UIView *backgroundView;

@end
@implementation ZXZDatePicker
- (instancetype)initWithDate:(NSString *)str{
   
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZXZDatePicker" owner:self options:nil] firstObject];
    if (self) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [format dateFromString:str];
        
        if (date != nil){
            self.datePicker.date = date;
        }
        
        self.backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        self.backgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
        [[UIApplication sharedApplication].keyWindow addSubview:self.backgroundView];
        [self.backgroundView addSubview:self];
        [self mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(0);
            make.right.mas_equalTo(0);
            make.bottom.mas_equalTo(500);
            make.height.mas_equalTo(260);
        }];
    }
    [self.cancelBtn setTitle:ZDLocalizedString(@"Cancel", nil) forState:UIControlStateNormal];
    [self.doneBtn setTitle:ZDLocalizedString(@"Done", nil) forState:UIControlStateNormal];
    return self;
}
- (void)showDatePicker {
    if (self.backgroundView) {
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1;
        }];
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.5f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}
- (void)hideDatePicker {
    if (self.backgroundView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0;
        } ];
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(300);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}

#pragma mark - UIButton Action
- (IBAction)cancelAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectInZXZDatePicker:)]) {
        [self.delegate cancelSelectInZXZDatePicker:self];
    }
}
- (IBAction)doneAction:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(datePicker:didSelectDate:)]) {
        NSDateFormatter *format = [[NSDateFormatter alloc] init];
        [format setDateFormat:@"yyyy-MM-dd"];
        NSString *str = [format stringFromDate:self.datePicker.date];
        [self.delegate datePicker:self didSelectDate:str];
    }
}
@end
