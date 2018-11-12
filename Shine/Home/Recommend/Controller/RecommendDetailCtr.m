//
//  RecommendDetailCtr.m
//  Shine
//
//  Created by oops on 2018/11/9.
//  Copyright © 2018 oops. All rights reserved.
//

#import "RecommendDetailCtr.h"

@interface RecommendDetailCtr ()

@property (nonatomic,strong)UIImageView *mainPicture;

@property (nonatomic,strong)UIView   *line;
@property (nonatomic,strong)UILabel  *downLabel;
@property (nonatomic,strong)UILabel  *downBtn;
@property (nonatomic,strong)UILabel  *downText;

@property (nonatomic,strong)UILabel  *descLabel;
@property (nonatomic,strong)UIButton *backBtn;


@end

@implementation RecommendDetailCtr

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    
    [self.mainPicture setImageURL:[NSURL URLWithString:self.img_url]];
    
}

-(void)createUI{
    self.mainPicture = [[UIImageView alloc] initWithFrame:UIScreen.mainScreen.bounds];
    _mainPicture.userInteractionEnabled = YES;
    [_mainPicture addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.72f animations:^{
            if (self.line.alpha == 0) {
                self.line.alpha = 0.78f;
                self.downLabel.alpha = 0.78f;
                self.downBtn.alpha = 0.78f;
                self.descLabel.alpha = 0.78f;
                self.backBtn.alpha = 0.78f;
            }else{
                self.line.alpha = 0;
                self.downLabel.alpha = 0;
                self.downBtn.alpha = 0;
                self.descLabel.alpha = 0;
                self.backBtn.alpha = 0;
            }
        }];
    }]];
    [self.view addSubview:self.mainPicture];
    
    //牵引线
    self.line = [[UIView alloc]initWithFrame:CGRectMake(ScreenWidth - 40, 0, 1, 138)];
    _line.backgroundColor = [UIColor whiteColor];
    _line.alpha = 0.78f;
    [self.view addSubview:_line];
    
    //下载作品的Label
    CGRect frame1 = CGRectMake(_line.x - 35, SafeAreaTopHeight - 44 + 18, 30, 130 - SafeAreaTopHeight + 44);
    self.downLabel = [UILabel labelWithText:@"下\n载\n作\n品\n" fontSize:FONT_SIZE_2 frame:frame1 color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    _downLabel.alpha = 0.78f;
    [self.view addSubview:_downLabel];
    
    //下载按钮
    CGRect frame2 = CGRectMake(_line.x - 15, _line.height, 31, 31);
    self.downBtn = [[UILabel alloc]initWithFrame:frame2];
    _downBtn.font = [UIFont systemFontOfSize:FONT_SIZE_4];
    _downBtn.backgroundColor = [UIColor whiteColor];
    _downBtn.textColor = [UIColor whiteColor];
    _downBtn.layer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/4);
    _downBtn.userInteractionEnabled = YES;
    [_downBtn addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        //下载图片
        [self downloadPicture:sender];
        
        CGFloat startY = SafeAreaTopHeight - 44 + 27;
        [UIView animateWithDuration:1 delay:0 options:0 animations:^{
            self.line.frame = CGRectMake(ScreenWidth - 15, startY, 1, 31);
            self.downLabel.width = 0;
            self.downLabel.height = 0;
            self.downBtn.center = CGPointMake(ScreenWidth - 40, startY + 15);
            self.downBtn.layer.affineTransform = CGAffineTransformRotate(CGAffineTransformIdentity, M_PI/2);
            self.downText.alpha = 0;
        } completion:^(BOOL finished) {
            
            [UIView animateWithDuration:1.0 animations:^{
                self.downBtn.frame = CGRectMake(ScreenWidth - 140, startY, 100, 31);
                self.downBtn.backgroundColor = [AppUtills getThemeColor];
                
                self.downBtn.alpha = 0.82;
                self.downText.alpha = 1;
                self.line.frame = CGRectMake(ScreenWidth - 31, startY, 15, 31);
                self.line.backgroundColor = [AppUtills getThemeColor];
            }];
            
        }];
    }]];
    [self.view addSubview:_downBtn];
    
    //下载文字
    CGFloat startY = SafeAreaTopHeight - 44 + 27;
    self.downText = [UILabel labelWithText:@"正在下载" fontSize:FONT_SIZE_3 frame:CGRectMake(ScreenWidth - 140, startY, 100, 31) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    self.downText.alpha = 0;
    [self.view addSubview:self.downText];
    
    CGRect frame3 = CGRectMake(ScreenWidth/2 - 105, ScreenHeight/2 - 30, 210, 60);
    self.descLabel = [UILabel labelWithText:[NSString stringWithFormat:@"%@\n%@",_pic_title,_destination] fontSize:FONT_SIZE_2 frame:frame3 color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
    _descLabel.backgroundColor = [AppUtills getThemeColor];
    _descLabel.alpha = 0.78f;
    [self.view addSubview:_descLabel];
    
    //返回按钮
    CGRect frame4 = CGRectMake(0, ScreenHeight - SafeAreaBottomHeight - 49, 49, 49);
    self.backBtn = [UIButton buttonWithLocalImage:@"back" title:@"" titleColor:COLOR_NULL_1 fontSize:FONT_SIZE_3 frame:frame4 click:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    [_backBtn setThemeBGColor];
    _backBtn.alpha = 0.78f;
    [self.view addSubview:_backBtn];
}

-(void)downloadPicture:(UIButton *)sender{
    
    if(self.mainPicture.image){
        UIImage *picture = self.mainPicture.image;
        
        UIImageWriteToSavedPhotosAlbum(picture, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
    }
    
}

- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        self.downText.text = @"下载成功";
        self.downBtn.userInteractionEnabled = NO;
    } else {
        self.downText.text = @"下载失败";
    }
}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    
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
