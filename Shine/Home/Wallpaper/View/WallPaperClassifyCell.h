//
//  WallPaperClassifyCell.h
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WallpaperDetailModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface WallPaperClassifyCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *urlimageView;

-(void)setUrlImage:(WallpaperDetailModel *)model;

@end


NS_ASSUME_NONNULL_END
