//
//  UILabel+Strickout.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/26.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UILabel+Strickout.h"

@implementation UILabel (Strickout)
- (void)setStrickoutString:(NSString *)string {
    if (string == nil){
        string = @"";
    }
    NSAttributedString *attrStr =
    [[NSAttributedString alloc]initWithString:string
                                   attributes:
     @{NSFontAttributeName:self.font,
       NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle|NSUnderlinePatternSolid),
       NSStrikethroughColorAttributeName:self.textColor}];
    [self setAttributedText:attrStr];
}

@end
