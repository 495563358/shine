//
//  UIButton+Util.h
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (Util)

typedef void(^clickBlock)(void);

+(UIButton *)buttonWithLocalImage:(nullable NSString *)image
                            title:(NSString *)title
                       titleColor:(nullable UIColor *)titleColor
                         fontSize:(CGFloat)fontSize
                            frame:(CGRect)frame
                            click:(clickBlock)clickBlock;

@end

NS_ASSUME_NONNULL_END
