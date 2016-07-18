//
//  UITextField+Indent.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/27.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UITextField+Indent.h"

@implementation UITextField (Indent)
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"
- (CGRect)textRectForBounds:(CGRect)bounds {
    if ([self isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
        return CGRectInset(bounds , 25 , 0 );
    }else{
        return CGRectInset(bounds , 8 , 0 );
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if ([self isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
        return CGRectInset(bounds , 25 , 0 );
    }else{
        return CGRectInset(bounds , 8, 0 );
    }
}
#pragma clang diagnostic pop
@end
