//
//  VBBaseNavigationController.m
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#import "VBBaseNavigationController.h"

@interface VBBaseNavigationController ()

@end

@implementation VBBaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBar.translucent = NO;
    [self.navigationBar setBackgroundImage:[self createImageWithColor:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    
    [self.navigationBar setShadowImage:[UIImage new]];
    /*
     设置title属性
     NSForegroundColorAttributeName:背景 设置为主题色
     
     */
    [self.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[AppUtills getThemeColor],NSFontAttributeName:[UIFont systemFontOfSize:FONT_SIZE_1]}];
}

-(UIImage *)createImageWithColor:(UIColor *)color

{
    
    CGRect rect=CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    
    CGContextFillRect(context, rect);
    
    
    
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return theImage;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
