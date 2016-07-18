//
//  CustomPickerView.h
//  beilu
//
//  Created by YKJ2 on 16/4/5.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZXZPickerView;
@protocol ZXZPickerViewDelegate <NSObject>
@optional
- (void)pickerView:(ZXZPickerView *)pickerView didSelectRow:(NSInteger )row;
- (void)cancelSelectInZXZPickerView:(ZXZPickerView *)pickerView;

@end

@interface ZXZPickerView : UIView
@property (weak, nonatomic) id<ZXZPickerViewDelegate> delegate;



- (instancetype)initWithContent:(NSArray *)array;
- (void)showPickerView;
- (void)hidePickerView;

@end
