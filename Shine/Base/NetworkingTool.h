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

+(AFHTTPSessionManager *)sharedManager;

@end

NS_ASSUME_NONNULL_END
