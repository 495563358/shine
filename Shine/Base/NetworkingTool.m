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
@end
