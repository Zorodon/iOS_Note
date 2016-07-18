//
//  AdPageControl.m
//  BeiLu
//
//  Created by YKJ2 on 16/6/28.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "AdPageControl.h"

@implementation AdPageControl
- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 5;
        size.width = 5;
        subview.layer.cornerRadius = 2.5;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
        if (subviewIndex == page){
            [subview setBackgroundColor:self.currentPageIndicatorTintColor];
        }else{
            [subview setBackgroundColor:self.pageIndicatorTintColor];
        }
    }
}
@end
