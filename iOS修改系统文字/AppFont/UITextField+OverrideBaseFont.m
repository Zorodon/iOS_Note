//
//  UITextField+OverrideBaseFont.m
//  BeiLu
//
//  Created by YKJ2 on 16/4/19.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "UITextField+OverrideBaseFont.h"
#import <objc/runtime.h>

@implementation UITextField (OverrideBaseFont)
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Method imp = class_getInstanceMethod([self class], @selector(initWithCoder:));
        Method myImp = class_getInstanceMethod([self class], @selector(myInitWithCoder:));
        method_exchangeImplementations(imp, myImp);
    });
}

- (id)myInitWithCoder:(NSCoder*)aDecode
{
    [self myInitWithCoder:aDecode];
    if (self) {
        if ([self.font.fontName rangeOfString:@"Bold"].location!=NSNotFound) {
            UIFont* font;
            if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"MICHAEL KORS"]) {
                
                font = [UIFont fontWithName:kGothamBoldAppFontBoldTypeName size:self.font.pointSize];
                
            }else if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"High Heels"]){
                
                font = [UIFont fontWithName:kAppGillSansFontTypeName size:self.font.pointSize];
                
            }else{
                
                font = [UIFont fontWithName:kDefaultAppFontBoldTypeName size:self.font.pointSize];
                
            }
            self.font = font;
        }else{
            UIFont* font;
            if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"MICHAEL KORS"]) {
                
                font = [UIFont fontWithName:kAppGothamBookFontTypeName size:self.font.pointSize];
                
            }else if ([[MainViewManager languageStye] hasPrefix:@"en"] && [AppName isEqualToString:@"High Heels"]){
                
                font = [UIFont fontWithName:kGillSansBoldAppFontBoldTypeName size:self.font.pointSize];
                
            }else{
                
                font = [UIFont fontWithName:kDefaultAppFontTypeName size:self.font.pointSize];
                
            }
            self.font = font;
        }
    }
    return self;
}
@end
