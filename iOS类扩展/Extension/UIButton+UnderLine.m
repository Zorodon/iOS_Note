//
//  UIButton+UnderLine.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/26.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UIButton+UnderLine.h"

@implementation UIButton (UnderLine)
- (void)setUnderLineString:(NSString *)string {
    NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:string];
    NSRange strRange = {0,[str length]};
    [str addAttribute:NSForegroundColorAttributeName value:self.currentTitleColor range:strRange];
    [str addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:strRange];
    [self setAttributedTitle:str forState:UIControlStateNormal];
}
@end
