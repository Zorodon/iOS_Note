//
//  WebViewController.h
//  BeiLu
//
//  Created by YKJ2 on 16/5/12.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LeftBaseViewController.h"

@interface WebViewController : LeftBaseViewController
@property (strong, nonatomic) NSString *path;
@property (assign, nonatomic) BOOL isFirst;

@end

