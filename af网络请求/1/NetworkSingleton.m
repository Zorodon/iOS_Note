//
//  NetworkSingleton.m
//  BeiLu
//
//  Created by YKJ1 on 16/4/11.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "NetworkSingleton.h"
#import "SecurityUtil.h"

#define AESKEY @"KDEFWkfdk249djka" //密钥key可修改
//******************************
//算法模式CBC
//密钥长度128
//密钥key
//密钥偏移量
//补码方式PKCS7Padding
//解密串编码方式 base64

@implementation NetworkSingleton

+(NetworkSingleton *)sharedManager{
    static NetworkSingleton *sharedNetworkSingleton = nil;
    static dispatch_once_t predicate;
    dispatch_once(&predicate,^{
        sharedNetworkSingleton = [[self alloc] init];
    });
    return sharedNetworkSingleton;
}
-(AFHTTPSessionManager *)baseHtppRequest{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setTimeoutInterval:TIMEOUT];
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"application/json", nil];

    return manager;
}

#pragma mark - post获取数据
-(void)postCWDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    
//    NSString *Pstring = [userInfo mj_JSONString];
    //AES 加密
    NSString *Pstring = [SecurityUtil encryptAESData:[userInfo mj_JSONString] app_key:AESKEY];
    
    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    [postParameter setObject:Pstring forKey:@"handler"];
    
    NSString *urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlStr parameters:postParameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject){
        
        NSString *decryptString = [responseObject objectForKey:@"handler"];
        //AES 解密
        successBlock([SecurityUtil decryptAESData:decryptString app_key:AESKEY]);
        
//        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

#pragma mark - post上传图片
-(void)postImageDataResult:(NSDictionary *)userInfo url:(NSString *)url imageData:(NSData *) imageData successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [self baseHtppRequest];
    
//    NSString *Pstring = [userInfo mj_JSONString];
    //AES 加密
    NSString *Pstring = [SecurityUtil encryptAESData:[userInfo mj_JSONString] app_key:AESKEY];
    
    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    [postParameter setObject:Pstring forKey:@"handler"];
    
    NSString *urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:urlStr parameters:postParameter constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        
        // 上传图片，以文件流的格式
        [formData appendPartWithFileData:imageData name:@"postimage" fileName:@"file.jpg" mimeType:@"image/jpeg"];
    
    }progress:nil success:^(NSURLSessionDataTask *operation, id responseObject){
        
        NSString *decryptString = [responseObject objectForKey:@"handler"];
        //AES 解密
        successBlock([SecurityUtil decryptAESData:decryptString app_key:AESKEY]);
        
//        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
    
}

#pragma mark - get获取数据
-(void)getCWDataResult:(NSDictionary *)userInfo url:(NSString *)url successBlock:(SuccessBlock)successBlock failureBlock:(FailureBlock)failureBlock{
    AFHTTPSessionManager *manager = [self baseHtppRequest];

//    NSString *Pstring = [userInfo mj_JSONString];
    //AES 加密
    NSString *Pstring = [SecurityUtil encryptAESData:[userInfo mj_JSONString] app_key:AESKEY];
    
    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    [postParameter setObject:Pstring forKey:@"handler"];
    
    NSString *urlStr = [url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
   
    [manager GET:urlStr parameters:postParameter progress:nil success:^(NSURLSessionDataTask *operation, id responseObject){
        
        NSString *decryptString = [responseObject objectForKey:@"handler"];
        //AES 解密
        successBlock([SecurityUtil decryptAESData:decryptString app_key:AESKEY]);
        
//        successBlock(responseObject);
        
    } failure:^(NSURLSessionDataTask *operation, NSError *error){
        NSString *errorStr = [error.userInfo objectForKey:@"NSLocalizedDescription"];
        failureBlock(errorStr);
    }];
}

@end
