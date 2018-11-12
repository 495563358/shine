//
//  WallpaperClassifyModel.m
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallpaperClassifyModel.h"

@implementation WallpaperClassifyModel

//重写赋值方法 把字典中的id 赋值 给Id
-(void)setValue:(id)value forUndefinedKey:(NSString *)key{
    if ([key isEqualToString:@"id"]) {
        self.Id = value;
    }
}

@end
