//
//  WallpaperDetailModel.h
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WallpaperDetailModel : NSObject

@property (nonatomic,copy) NSString *guid;
@property (nonatomic,copy) NSString *type;
@property (nonatomic,copy) NSString *cat;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *thumb_hd;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,copy) NSString *cover_hd;
@property (nonatomic,copy) NSString *cover_hd_568h;
@property (nonatomic,copy) NSString *cover_hd_812h;
@property (nonatomic,copy) NSString *pubdate;
@property (nonatomic,copy) NSString *archive_timestamp;
@property (nonatomic,copy) NSString *timestamp;
@property (nonatomic,copy) NSString *summary;
@property (nonatomic,copy) NSString *content;
@property (nonatomic,copy) NSString *latitude;
@property (nonatomic,copy) NSString *longitude;
@property (nonatomic,copy) NSString *geo_span;
@property (nonatomic,copy) NSString *has_video;
@property (nonatomic,copy) NSString *has_caption;
@property (nonatomic,copy) NSString *has_location;
@property (nonatomic,copy) NSString *has_toolbar;
@property (nonatomic,copy) NSString *enable_wechat;
@property (nonatomic,copy) NSString *title_wechat;
@property (nonatomic,copy) NSString *link_share;
@property (nonatomic,copy) NSString *link_wechat;
@property (nonatomic,copy) NSString *is_focus;
@property (nonatomic,copy) NSString *is_banner;
@property (nonatomic,copy) NSString *news_count;

@end

NS_ASSUME_NONNULL_END
