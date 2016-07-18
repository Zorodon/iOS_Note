//
//  LoginView.h
//  beilu
//
//  Created by YKJ2 on 16/4/5.
//  Copyright © 2016年 YKJ2. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^CreateAccountBlock)(void);
typedef void (^SignInBlock)(void);
typedef void (^SkipBlock)(void);

@interface LoginView : UIView
@property (nonatomic, copy) CreateAccountBlock createAccountBlock;
@property (nonatomic, copy) SignInBlock signInBlock;
@property (nonatomic, copy) SkipBlock skipBlock;

@property (nonatomic, weak) IBOutlet UIButton *createBtn;
@property (nonatomic, weak) IBOutlet UIButton *signBtn;
@property (nonatomic, weak) IBOutlet UIButton *skipBtn;

@property (strong, nonatomic) UIView *backgroundView;

- (instancetype)init;
- (instancetype)initInMaskView;

@end
