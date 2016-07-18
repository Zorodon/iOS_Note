//
//  LoginedView.h
//  BeiLu
//
//  Created by YKJ2 on 16/5/4.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SignInBlock)(void);
typedef void (^ChangeBlock)(void);

@interface LoginedView : UIView
@property (nonatomic, copy) SignInBlock signInBlock;
@property (nonatomic, copy) ChangeBlock changeBlock;

- (instancetype)initWithImage:(NSString *)imageUrl title:(NSString *)title;
@end
