//
//  NSString+LineSpace.m
//  BeiLu
//
//  Created by YKJ2 on 16/7/14.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "NSString+LineSpace.h"

@implementation NSString (LineSpace)

- (NSAttributedString *)lineSpaceAttributedStringWithSpace:(CGFloat)space {
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];//调整行间距
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.length)];
    return attributedString;
}

@end
