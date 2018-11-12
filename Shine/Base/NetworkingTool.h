//
//  NetworkingTool.h
//  ARDoor
//
//  Created by oops on 2018/10/17.
//  Copyright © 2018年 Minecode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface NetworkingTool : NSObject

typedef void(^SuccessBlock)(id object);//成功回传数据
typedef void(^FailureBlock)(NSError *error);//失败回传数据

+(AFHTTPSessionManager *)sharedManager;

+(void)getRequest:(NSString *)urlStr andParagram:(nullable NSDictionary *)paragram completation:(SuccessBlock)success failure:(FailureBlock)failure;

@end

NS_ASSUME_NONNULL_END
