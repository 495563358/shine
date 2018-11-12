//
//  WallpaperClassifyModel.h
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WallpaperClassifyModel : NSObject
@property (nonatomic,copy) NSString *Id;
@property (nonatomic,copy) NSString *alias;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,strong) NSArray *thumbs;
@property (nonatomic,copy) NSString *type;
@end

NS_ASSUME_NONNULL_END
