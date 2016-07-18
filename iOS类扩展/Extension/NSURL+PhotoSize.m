//
//  NSURL+PhotoSize.m
//  BeiLu
//
//  Created by YKJ2 on 16/6/16.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "NSURL+PhotoSize.h"

@implementation NSURL (PhotoSize)

//图片路径添加大小 xxxx/abc.png  -->  xxxx/h100/abc.png 或 xxxx/w100/abc.png
+ (NSURL *)URLWithString:(NSString *)string size:(CGSize)size {
    if (string.length == 0 || string == nil){
        return [self URLWithString:string];
    }
    CGFloat width = [self hundredFloat:size.width*2];
    CGFloat height = [self hundredFloat:size.height*2];
    
    NSString *sizeStr;
    if (width>height) {
        sizeStr = [NSString stringWithFormat:@"w%.0f/",width];
    }else{
        sizeStr = [NSString stringWithFormat:@"h%.0f/",height];
    }
    
    NSArray *arr = [string componentsSeparatedByString:@"/"];
    NSMutableString *urlStr = [NSMutableString stringWithString:string];
    NSString *lastStr = [arr lastObject];
    if (arr.count>0 && width<=1000 && height<=1000) {
        [urlStr deleteCharactersInRange:NSMakeRange(urlStr.length-lastStr.length, lastStr.length)];
        [urlStr appendString:sizeStr];
        [urlStr appendString:lastStr];
//        NSLog(@"%@",urlStr);
        return [self URLWithString:urlStr];
    }else{
        return [self URLWithString:string];
    }
}

//向上取整百
+ (CGFloat)hundredFloat:(CGFloat )aFloat {
    CGFloat bFloat = aFloat/100.0;
    CGFloat cFloat = ceil(bFloat);
    return cFloat*100;
}

@end
