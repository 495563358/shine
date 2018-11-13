//
//  WallClassifyHeaderView.m
//  Shine
//
//  Created by oops on 2018/11/13.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallClassifyHeaderView.h"

@interface WallClassifyHeaderView()

@property (weak, nonatomic) IBOutlet UILabel *english;
@property (weak, nonatomic) IBOutlet UILabel *chinese;


@end

@implementation WallClassifyHeaderView

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)setModel:(WallpaperClassifyModel *)model{
    self.english.text = model.title;
    self.chinese.text = model.name;
}

@end
