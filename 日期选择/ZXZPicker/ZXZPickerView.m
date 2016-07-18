//
//  CustomPickerView.m
//  beilu
//
//  Created by YKJ2 on 16/4/5.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import "ZXZPickerView.h"


@interface ZXZPickerView()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, weak) IBOutlet UIButton *cancelBtn;
@property (nonatomic, weak) IBOutlet UIButton *doneBtn;

@property (strong, nonatomic) NSArray *datas;
@property (assign, nonatomic) NSInteger selectRow;
@property (strong, nonatomic) UIView *backgroundView;

@end

@implementation ZXZPickerView

- (instancetype)initWithContent:(NSArray *)array{
    self = [[[NSBundle mainBundle] loadNibNamed:@"ZXZPickerView" owner:self options:nil] firstObject];
    if (self) {
        self.pickerView.delegate = self;
        self.datas = [NSArray arrayWithArray:array];
        
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

- (void)showPickerView {
    if (self.backgroundView) {
        self.backgroundView.alpha = 0;
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 1;
        }];
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(0);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}
- (void)hidePickerView {
    if (self.backgroundView) {
        [UIView animateWithDuration:0.3 animations:^{
            self.backgroundView.alpha = 0;
        }];
        
        [self.superview layoutIfNeeded];
        [UIView animateWithDuration:0.3f animations:^{
            [self mas_updateConstraints:^(MASConstraintMaker *make) {
                make.bottom.mas_equalTo(300);
            }];
            [self.superview layoutIfNeeded];
        }];
    }
}

#pragma mark - UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return self.datas.count;
}

- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.datas[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    self.selectRow = row;
}

#pragma mark - UIButton Action
- (IBAction)CancelAction:(id)sender {
    [self hidePickerView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelSelectInZXZPickerView:)]) {
        [self.delegate cancelSelectInZXZPickerView:self];
    }

}
- (IBAction)DoneAction:(id)sender {
    [self hidePickerView];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pickerView:didSelectRow:)]) {
        [self.delegate pickerView:self didSelectRow:self.selectRow];
    }

}

@end
