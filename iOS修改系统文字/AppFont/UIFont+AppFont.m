//
//  UIFont+AppFont.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/19.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UIFont+AppFont.h"


@implementation UIFont (AppFont)

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-protocol-method-implementation"

+ (UIFont *)systemFontOfSize:(CGFloat)fontSize {
    if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"MICHAEL KORS"]) {
        
        return [UIFont fontWithName:kAppGothamBookFontTypeName  size:fontSize];
        
    }else if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"High Heels"]){
        
        return [UIFont fontWithName:kAppGillSansFontTypeName size:fontSize];
        
    }else{
        
        return [UIFont fontWithName:kDefaultAppFontTypeName  size:fontSize];
        
    }
}

+ (UIFont *)boldSystemFontOfSize:(CGFloat)fontSize {
    if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"MICHAEL KORS"]) {
        
        return [UIFont fontWithName:kGothamBoldAppFontBoldTypeName  size:fontSize];
        
    }else if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"High Heels"]){
        
        return [UIFont fontWithName:kGillSansBoldAppFontBoldTypeName size:fontSize];
        
    }else{
        
        return [UIFont fontWithName:kDefaultAppFontBoldTypeName  size:fontSize];
        
    }
    
}
#pragma clang diagnostic pop

@end
