//
//  UILabel+DynamicSize.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/18.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UILabel+DynamicSize.h"

@implementation UILabel (DynamicSize)
-(CGFloat)expectedHeightWithWidth:(CGFloat)width {
    [self setNumberOfLines:0];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize maximumLabelSize = CGSizeMake(width,MAXFLOAT);
    NSDictionary *attributes2 = @{NSFontAttributeName: [self font]};
    CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes2
                                                         context:nil];
    return expectedLabelRect.size.height;
}

-(CGFloat)expectedWidth{
    [self setNumberOfLines:1];
    [self setLineBreakMode:NSLineBreakByWordWrapping];
    CGSize maximumLabelSize = CGSizeMake(MAXFLOAT,self.frame.size.height);
    NSDictionary *attributes2 = @{NSFontAttributeName: [self font]};
    CGRect expectedLabelRect = [[self text] boundingRectWithSize:maximumLabelSize
                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                      attributes:attributes2
                                                         context:nil];
    return expectedLabelRect.size.width;
}


@end
