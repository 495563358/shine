//
//  AppUtills.h
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface AppUtills : NSObject

+ (void)saveObject:(id)object forKey:(NSString *)key;

+ (id)getObjectForKey:(NSString *)key;

+ (UIColor *)getThemeColor;
+ (UIColor *)getThemeLightColor;

+ (void)setColorAtIndex:(int)index;

@end

NS_ASSUME_NONNULL_END
