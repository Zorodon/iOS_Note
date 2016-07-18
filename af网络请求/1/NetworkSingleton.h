//
//  NetworkSingleton.h
//  BeiLu
//
//  Created by YKJ1 on 16/4/11.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

//请求超时
#define TIMEOUT 30

typedef void(^SuccessBlock)(id responseBody);
typedef void(^FailureBlock)(NSString *error);


@interface NetworkSingleton : NSObject

+(NetworkSingleton *)sharedManager;
-(AFHTTPSessionManager *)baseHtppRequest;


#pragma mark - post获取数据
-(void)postCWDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;

-(void)postImageDataResult:(NSDictionary *)userInfo url:(NSString *)url imageData:(NSData *) imageData successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;
#pragma mark - get获取数据
-(void)getCWDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock;


@end
