//
//  UITextField+Shake.m
//  BeiLu
//
//  Created by YKJ2 on 16/5/17.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UITextField+Shake.h"
@interface UITextField ()

@end

@implementation UITextField (Shake)

//左右震动效果
- (void)shake {
    CGRect frame = self.frame;
    CAKeyframeAnimation *shakeAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    
    CGMutablePathRef shakePath = CGPathCreateMutable();
    CGPathMoveToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2, frame.origin.y+frame.size.height/2);
    int index;
    for (index = 3; index >=0; --index) {
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 - 2*index, frame.origin.y+frame.size.height/2);
        CGPathAddLineToPoint(shakePath, NULL, frame.origin.x+frame.size.width/2 + 2*index, frame.origin.y+frame.size.height/2);
    }
    CGPathCloseSubpath(shakePath);
    
    shakeAnimation.delegate = self;
    shakeAnimation.path = shakePath;
    shakeAnimation.duration = 0.5f;
    shakeAnimation.removedOnCompletion = YES;
    
    [self.layer addAnimation:shakeAnimation forKey:nil];
    CFRelease(shakePath);
    
    self.textColor = [UIColor redColor];
    self.layer.borderColor = [UIColor redColor].CGColor;
}

- (void) animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
    self.textColor = UIColorWithRGBA(77, 77, 77, 1);

}
@end
