//
//  WallpaperController.m
//  Shine
//
//  Created by oops on 2018/11/14.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallpaperController.h"
#import <MapKit/MapKit.h>
#import "QYAnnotation.h"

@interface WallpaperController ()

@property(nonatomic,strong) UIImageView *imageView;
@property(nonatomic,strong) UIView *bottomView;

@property (nonatomic,strong)UILabel *dateLab;
@property (nonatomic,strong)UILabel *desclab;
@property (nonatomic,strong)MKMapView *mapView;

@property (nonatomic,strong)UIView *deskBackView;
@property (nonatomic,strong)UIView *lockBackView;

@end

@implementation WallpaperController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSLog(@"%@",self.model);
    
    _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    [self.view addSubview:_imageView];
    NSString *imageUrl = _model.cover_hd_568h;
    if (ScreenHeight == 812) {
        if (_model.cover_hd_812h) {
            imageUrl = _model.cover_hd_812h;
        }
    }
    [_imageView loadProgressImageWithUrl:imageUrl complete:nil];
    
    [self createBottomUI];
    
    //为imageView添加点击事件
    _imageView.userInteractionEnabled = YES;
    [_imageView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
        [UIView animateWithDuration:0.8f delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            if (self.bottomView.top == ScreenHeight - 50) {
                self.bottomView.bottom = ScreenHeight;
            }else{
                self.bottomView.top = ScreenHeight - 50;
            }
        } completion:nil];
    }]];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [UIView animateWithDuration:1.5f delay:0 usingSpringWithDamping:0.4 initialSpringVelocity:0.8f options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.bottomView.top = ScreenHeight - 50;
    } completion:nil];
    
}

-(void)createBottomUI{
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight, ScreenWidth, ScreenHeight/2 - 20)];
    _bottomView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.8];
    [self.view addSubview:_bottomView];
    
    NSArray *titleArr = @[@"返回",@"保存",@"分享",@"预览"];
    NSArray *imageArr = @[@"ButtonBack",@"ButtonDownload",@"ButtonShare",@"ButtonPreview"];
    
    for (int i = 0; i<4; i++) {
        __block UIButton *btn = [UIButton buttonWithLocalImage:imageArr[i] title:titleArr[i] titleColor:[UIColor whiteColor] fontSize:FONT_SIZE_3 frame:CGRectMake(i * ScreenWidth/4, 5, ScreenWidth/4, 30) click:^{
            //按钮点击事件
            switch (btn.tag) {
                case 1:
                    [self dismissViewControllerAnimated:YES completion:nil];
                    break;
                case 2:
                    UIImageWriteToSavedPhotosAlbum(self.imageView.image, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
                    break;
                case 3:
                {
                    NSURL *url = [NSURL URLWithString:self.model.cover_hd_568h];
                    UIImage *image = self.imageView.image;
                    NSString *title = self.model.title_wechat;
                    NSArray *activityItems = @[title,image,url];
                    UIActivityViewController *activityViewController =
                    [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
                    [self presentViewController:activityViewController animated:YES completion:nil];
                    [activityViewController setCompletionWithItemsHandler:^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
                        if (completed) {
                            [SVProgressHUD showSuccessWithStatus:@"分享成功"];
                        }
                    }];
                    
                    break;
                }
                case 4:{
                    UIAlertController *alertCtr = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
                    
                    UIAlertAction *deskLook = [UIAlertAction actionWithTitle:@"主屏幕预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self deskLookup];
                    }];
                    UIAlertAction *lockLook = [UIAlertAction actionWithTitle:@"锁屏预览" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                        [self lockLookup];
                    }];
                    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
                    }];
                    [alertCtr addAction:deskLook];
                    [alertCtr addAction:lockLook];
                    [alertCtr addAction:cancel];
                    [self presentViewController:alertCtr animated:YES completion:nil];
                    break;
                    
                }
                default:
                    break;
            }
            
        }];
        btn.tag = i + 1;
        [_bottomView addSubview:btn];
    }
    
    //日期和描述
    _dateLab = [UILabel labelWithText:_model.pubdate fontSize:FONT_SIZE_2 frame:CGRectMake(10, 60, ScreenWidth, 30) color:[UIColor whiteColor] textAlignment:0];
    [_bottomView addSubview:_dateLab];
    
    _desclab = [UILabel labelWithText:_model.content fontSize:FONT_SIZE_4 frame:CGRectMake(10, 95, ScreenWidth - 20, 80) color:[UIColor whiteColor] textAlignment:0];
    [_bottomView addSubview:_desclab];
    [_desclab sizeToFit];
    
    CGFloat descBottom = _desclab.y + _desclab.height + 10;
    _mapView = [[MKMapView alloc]initWithFrame:CGRectMake(10, descBottom, ScreenWidth - 20, _bottomView.height - 20 - descBottom)];
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([_model.latitude doubleValue], [_model.longitude doubleValue]);
    
    
    //反向地理编码
    
    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLLocation *cl = [[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude];
    
    [clGeoCoder reverseGeocodeLocation:cl completionHandler: ^(NSArray *placemarks,NSError *error) {
        
        QYAnnotation *annotation = [[QYAnnotation alloc] init];
        annotation.coordinate = coordinate;
        //    annotation.annotation.title = @"";
        [self.mapView addAnnotation:annotation];
        [self.mapView setRegion:MKCoordinateRegionMakeWithDistance(coordinate, 2000, 2000)];
        [self.bottomView addSubview:self.mapView];
        
        if (error){
            return ;
        }
        for (CLPlacemark *placeMark in placemarks) {
            
            NSDictionary *addressDic = placeMark.addressDictionary;
            
            NSString *state=[addressDic objectForKey:@"State"];
            
            NSString *city=[addressDic objectForKey:@"City"];
            
            NSString *subLocality=[addressDic objectForKey:@"SubLocality"];
            
            NSString *street=[addressDic objectForKey:@"Street"];
            
            NSLog(@"所在城市====%@ %@ %@ %@", state, city, subLocality, street);
            
            annotation.title = city;
        }
        
    }];
    
}

//主屏幕预览
-(void)deskLookup{
    if (!_deskBackView) {
        _deskBackView = [[UIView alloc]initWithFrame:UIScreen.mainScreen.bounds];
        
        UIImageView *topImg = [UIImageView imageViewWithLocalImage:@"BackgroundHomeScreenTop-OS7" frame:CGRectMake(0, SafeAreaTopHeight - 44 + 20, ScreenWidth, ScreenWidth/960*1116)];
        [_deskBackView addSubview:topImg];
        
        UIImageView *bottomImg = [UIImageView imageViewWithLocalImage:@"BackgroundHomeScreenBottom-OS7" frame:CGRectMake(5, ScreenHeight - SafeAreaBottomHeight - 5 - (ScreenWidth - 10)/64 * 20 , ScreenWidth - 10, (ScreenWidth - 10)/64 * 20)];
        bottomImg.backgroundColor = [COLOR_NULL_7 colorWithAlphaComponent:0.6];
        [_deskBackView addSubview:bottomImg];
        [self.view addSubview:_deskBackView];
        
        [_deskBackView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            self.deskBackView.hidden = YES;
            self.bottomView.hidden = NO;
        }]];
    }
    
    self.bottomView.hidden = YES;
    _deskBackView.hidden = NO;
    
}

//锁屏预览
-(void)lockLookup{
    
}


//保存图片
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功"];
    } else {
        [SVProgressHUD showErrorWithStatus:@"保存失败,请检查网络设置并允许本程序访问相册"];
    }
    [SVProgressHUD dismissWithDelay:2];
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
