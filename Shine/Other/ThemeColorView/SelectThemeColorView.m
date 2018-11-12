//
//  SelectThemeColorView.m
//  Shine
//
//  Created by oops on 2018/11/1.
//  Copyright © 2018 oops. All rights reserved.
//

#import "SelectThemeColorView.h"

@interface SelectThemeColorView()
@property (weak, nonatomic) IBOutlet UIButton *hideBtn;

@property (weak, nonatomic) IBOutlet UIButton *colorView1;
@property (weak, nonatomic) IBOutlet UIButton *colorView2;
@property (weak, nonatomic) IBOutlet UIButton *colorView3;
@property (weak, nonatomic) IBOutlet UIButton *colorView4;
@property (weak, nonatomic) IBOutlet UIButton *colorView5;
@property (weak, nonatomic) IBOutlet UIButton *colorView6;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *hidebtnBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view1Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view2Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view3Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view4Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view6Bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *view5Bottom;


@end

@implementation SelectThemeColorView
- (IBAction)hideBtnClick:(id)sender {
    [self hide];
}

/*
 类方法 选择系统主题色
 从Nib中获取控件
 设置进场动画
 */
+ (void) showSelect{
    
    NSArray *arr = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil];
    SelectThemeColorView *colorView = arr[0];
    
    [KeyWindow addSubview:colorView];
    [colorView showWithAnimation];
}

/*
 进场动画
 */
-(void)showWithAnimation{
    [UIView animateWithDuration:0.4 animations:^{
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.68];
    } completion:^(BOOL finished) {
        [self colorViewStartAnimationWithConstant:368 andBottom:self.view1Bottom andDelay:1];
        [self colorViewStartAnimationWithConstant:368 andBottom:self.view2Bottom andDelay:2];
        [self colorViewStartAnimationWithConstant:368 andBottom:self.view3Bottom andDelay:3];
        [self colorViewStartAnimationWithConstant:228 andBottom:self.view4Bottom andDelay:4];
        [self colorViewStartAnimationWithConstant:228 andBottom:self.view5Bottom andDelay:5];
        [self colorViewStartAnimationWithConstant:228 andBottom:self.view6Bottom andDelay:6];
        
        CGAffineTransform transform = CGAffineTransformIdentity;
        transform = CGAffineTransformRotate(transform, M_PI_2);
        self.hidebtnBottom.constant = 70;
        [UIView animateWithDuration:0.6f delay:0.8f options:UIViewAnimationOptionCurveEaseOut animations:^{
            self.hideBtn.layer.affineTransform = transform;
            [self layoutIfNeeded];
        } completion:nil];
        
    }];
}

//隐藏动画
-(void)hide{
    
    CGAffineTransform transform = CGAffineTransformIdentity;
    transform = CGAffineTransformRotate(transform, -M_PI_2);
    self.hidebtnBottom.constant = -self.hideBtn.height - 24;
    [UIView animateWithDuration:0.6f delay:0.1f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.hideBtn.layer.affineTransform = transform;
        [self layoutIfNeeded];
    } completion:^(BOOL finished) {
        self.backgroundColor = [UIColor clearColor];
        [self removeFromSuperview];
    }];
    
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view6Bottom andDelay:2];
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view5Bottom andDelay:3];
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view4Bottom andDelay:4];
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view3Bottom andDelay:5];
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view2Bottom andDelay:6];
    [self colorViewStartAnimationWithConstant:-124 andBottom:self.view1Bottom andDelay:7];
    
}

/*
 设置单个View的偏移动画
 usingSpringWithDamping 弹簧效果
 initialSpringVelocity  初始速度
 options    动画效果
 */
-(void)colorViewStartAnimationWithConstant:(CGFloat)height andBottom:(NSLayoutConstraint *)bottomconstant andDelay:(CGFloat)delaytime{
    
    bottomconstant.constant = height;
    [UIView animateWithDuration:1 delay:0.07f * delaytime usingSpringWithDamping:0.72f initialSpringVelocity:5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        [self layoutIfNeeded];
    } completion:nil];
}

//从xib中获取后把控件位置下移
-(void)awakeFromNib{
    [super awakeFromNib];
    self.frame = UIScreen.mainScreen.bounds;
    self.backgroundColor = [UIColor clearColor];
    
    [self.colorView1 setGradientBGColorWithTopColor:COLOR_1_LIGHT bottomColor:COLOR_1];
    [self.colorView2 setGradientBGColorWithTopColor:COLOR_2_LIGHT bottomColor:COLOR_2];
    [self.colorView3 setGradientBGColorWithTopColor:COLOR_3_LIGHT bottomColor:COLOR_3];
    [self.colorView4 setGradientBGColorWithTopColor:COLOR_4_LIGHT bottomColor:COLOR_4];
    [self.colorView5 setGradientBGColorWithTopColor:COLOR_5_LIGHT bottomColor:COLOR_5];
    [self.colorView6 setGradientBGColorWithTopColor:COLOR_6_LIGHT bottomColor:COLOR_6];
    
    self.colorView1.alpha = self.colorView2.alpha = self.colorView3.alpha = self.colorView4.alpha = self.colorView5.alpha = self.colorView6.alpha = 0.82;
    
    [self.hideBtn setCornerRadius:self.hideBtn.height/2];
    self.hideBtn.backgroundColor = [UIColor whiteColor];
    
    self.hidebtnBottom.constant = -self.hideBtn.height - 24;
    self.view1Bottom.constant = -124;
    self.view2Bottom.constant = -124;
    self.view3Bottom.constant = -124;
    self.view4Bottom.constant = -124;
    self.view5Bottom.constant = -124;
    self.view6Bottom.constant = -124;
    
    [self layoutIfNeeded];
    
    NSArray *arr = @[self.colorView1,self.colorView2,self.colorView3,self.colorView4,self.colorView5,self.colorView6];
    for (int index = 0; index < arr.count; index ++) {
        UIView *view = arr[index];
        [view addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            
            [self hide];
            //设置主题色
            [AppUtills setColorAtIndex:index];
            
        }]];
    }
    
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
