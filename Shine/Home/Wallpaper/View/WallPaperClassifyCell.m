//
//  WallPaperClassifyCell.m
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallPaperClassifyCell.h"

@interface WallPaperClassifyCell()



@end

@implementation WallPaperClassifyCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.urlimageView.layer.cornerRadius = 5.0;
    self.urlimageView.layer.masksToBounds = YES;
}

-(void)setUrlImage:(WallpaperDetailModel *)model{
    [_urlimageView setImageURL:[NSURL URLWithString:model.thumb]];
}

@end
