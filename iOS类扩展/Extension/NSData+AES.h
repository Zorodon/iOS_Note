//
//  NSData+AES.h
//  BeiLu
//
//  Created by YKJ1 on 16/5/26.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#ifndef NSData_AES_h
#define NSData_AES_h

#import <Foundation/Foundation.h>

@class NSString;

@interface NSData (Encryption)

- (NSData *)AES128EncryptWithKey:(NSString *)key;   //加密
- (NSData *)AES128DecryptWithKey:(NSString *)key;   //解密

@end

#endif /* NSData_AES_h */
