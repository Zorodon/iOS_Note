//
//  ZXZDatePicker.h
//  beilu
//
//  Created by YKJ2 on 16/4/6.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXZDatePicker;
@protocol ZXZDatePickerDelegate <NSObject>
@optional
- (void)datePicker:(ZXZDatePicker *)datePicker didSelectDate:(NSString *)date;
- (void)cancelSelectInZXZDatePicker:(ZXZDatePicker *)datePicker;

@end

@interface ZXZDatePicker : UIView
@property (weak, nonatomic) id<ZXZDatePickerDelegate> delegate;

- (instancetype)initWithDate:(NSString *)str;
- (void)showDatePicker;
- (void)hideDatePicker;
@end
