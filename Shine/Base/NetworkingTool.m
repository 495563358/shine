//
//  NetworkingTool.m
//  ARDoor
//
//  Created by oops on 2018/10/17.
//  Copyright © 2018年 Minecode. All rights reserved.
//

#import "NetworkingTool.h"

@implementation NetworkingTool

static AFHTTPSessionManager *afnManager = nil;

+(AFHTTPSessionManager *)sharedManager{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        afnManager = [AFHTTPSessionManager manager];
        afnManager.requestSerializer.timeoutInterval = 10.0;
        afnManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        afnManager.responseSerializer = [AFJSONResponseSerializer serializer];
        afnManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"application/x-json",@"text/html",@"text/plain", nil];
        
    });
    return afnManager;
}

+(void)getRequest:(NSString *)urlStr andParagram:(nullable NSDictionary *)paragram completation:(SuccessBlock)success failure:(FailureBlock)failure{
    [[NetworkingTool sharedManager] GET:urlStr parameters:paragram progress:^(NSProgress * _Nonnull downloadProgress) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [SVProgressHUD showProgress:downloadProgress.fractionCompleted status:[NSString stringWithFormat:@"加载中:%.0f%%",downloadProgress.fractionCompleted * 100]];
        });
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [SVProgressHUD showSuccessWithStatus:nil];
        [SVProgressHUD dismissWithDelay:1.5f];
        if (success) {
            success(responseObject);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
        [SVProgressHUD showErrorWithStatus:error.domain];
        [SVProgressHUD dismissWithDelay:1.5f];
    }];
}

@end
