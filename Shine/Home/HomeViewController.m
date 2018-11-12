//
//  HomeViewController.m
//  Shine
//
//  Created by oops on 2018/10/31.
//  Copyright © 2018 oops. All rights reserved.
//

#import "HomeViewController.h"
#import "SelectThemeColorView.h"
#import "Recommend/Controller/RecommendViewController.h"//推荐首页
#import "WallpaperClassifyController.h"//壁纸首页

@interface HomeViewController ()
/*
 存放按钮  @[@"作品",@"今日",@"壁纸"]
 */
@property (nonatomic,strong) NSMutableArray *datas;
@property (nonatomic,strong) UIView *navTitleview;
@property (nonatomic,strong) UILabel *colorLabel;

@property (nonatomic,strong) UIScrollView *scrollView;


@end

@implementation HomeViewController

#pragma mark - Lazy load
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(UIView *)navTitleview{
    if (!_navTitleview) {
        NSArray *titles = @[@"作品",@"今日",@"壁纸"];
        _navTitleview = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60 * titles.count, 36)];
        CGFloat w = 60;
        CGFloat h = 36;
        for (int i = 0 ; i < titles.count; i++) {
            UIButton *btn = [UIButton buttonWithLocalImage:nil title:titles[i] titleColor:COLOR_NULL_3 fontSize:FONT_SIZE_3 frame:CGRectMake(w * i, 0, w, h) click:^{
                [self clickTitleAtIndex:i];
            }];
            [_navTitleview addSubview:btn];
            [self.datas addObject:btn];
        }
        
    }
    return _navTitleview;
}

-(UILabel *)colorLabel{
    if (!_colorLabel) {
        _colorLabel = [UILabel labelWithText:@"C" fontSize:FONT_SIZE_2 frame:CGRectMake(0, 0, 30, 30) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        _colorLabel.userInteractionEnabled = YES;
        [_colorLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [SelectThemeColorView showSelect];
        }]];
    }
    return _colorLabel;
}

-(UIScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight)];
        _scrollView.scrollEnabled = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.contentSize = CGSizeMake(ScreenWidth * 3, ScreenHeight - SafeAreaTopHeight);
        RecommendViewController *recommend = [RecommendViewController new];
        [self addChildViewController:recommend];
        recommend.view.frame = CGRectMake(ScreenWidth, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight);
        [_scrollView addSubview:recommend.view];
        
        WallpaperClassifyController *wallpaper = [WallpaperClassifyController new];
        [self addChildViewController:wallpaper];
        wallpaper.view.frame = CGRectMake(ScreenWidth * 2, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight);
        
        [_scrollView addSubview:wallpaper.view];
    }
    return _scrollView;
}

#pragma mark - Viewload
- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
}

-(void)createUI{
    self.navigationItem.titleView = self.navTitleview;
    
    UIView *rightView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
    [rightView addSubview:self.colorLabel];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightView];
    
    [self.view addSubview:self.scrollView];
    
    [self reloadAppColor];
}

-(void)reloadThemeColor{
    [self reloadAppColor];
}

- (void)reloadAppColor{
    [self clickTitleAtIndex:1];
    [self.colorLabel.superview setThemeBGColor];
}

- (void)clickTitleAtIndex:(NSInteger)index {
    //1.改变按钮颜色
    for (UIButton *btn in self.datas) {
        [btn setTitleColor:COLOR_NULL_3 forState:UIControlStateNormal];
        btn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_3];
    }
    UIButton *selectBtn = self.datas[index];
    [selectBtn setTitleColor:[AppUtills getThemeColor] forState:UIControlStateNormal];
    selectBtn.titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_1];
    //2.scrollview偏移
    [self.scrollView setContentOffset:CGPointMake(index * ScreenWidth, 0) animated:YES];
    
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
