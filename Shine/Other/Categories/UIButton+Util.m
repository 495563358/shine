//
//  UIButton+Util.m
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#import "UIButton+Util.h"

@implementation UIButton (Util)

//image,title
+(UIButton *)buttonWithLocalImage:(nullable NSString *)image
                            title:(NSString *)title
                       titleColor:(nullable UIColor *)titleColor
                         fontSize:(CGFloat)fontSize
                            frame:(CGRect)frame
                            click:(clickBlock)clickBlock {
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = frame;
    if (image.length > 0) {
        [btn setImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    }
    [btn setTitle:title forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    if (titleColor != nil) {
        [btn setTitleColor:titleColor forState:UIControlStateNormal];
    }
    
    [btn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        if (clickBlock) {
            clickBlock();
        }
    }];
    return btn;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
