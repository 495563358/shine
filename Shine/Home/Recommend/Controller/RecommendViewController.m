//
//  RecommendViewController.m
//  Shine
//
//  Created by oops on 2018/11/8.
//  Copyright © 2018 oops. All rights reserved.
//

#import "RecommendViewController.h"
#import "NewPagedFlowView.h"
#import "RecommendModel.h"
#import "PGIndexBannerSubiew.h"
#import "RecommendDetailCtr.h"

#define PageViewSafeHeight 40
#define PageViewSafeWeight 25


@interface RecommendViewController()<NewPagedFlowViewDelegate,NewPagedFlowViewDataSource>

@property (nonatomic ,strong)NSMutableArray *datas;
@property (nonatomic ,strong)NewPagedFlowView *pageView;

@property (nonatomic ,strong)UIView *loadingView;
@property (nonatomic ,strong)UIImageView *loadfail;
@property (nonatomic ,strong)UILabel *timeLabel;

@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic,assign) BOOL flag_pop;//记录能否跳转
@property (nonatomic,assign) int dayindex;//记录前面的天数

@end


@implementation RecommendViewController

#pragma mark - lazy load
- (NSMutableArray *)datas {
    if (_datas == nil) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}

-(NewPagedFlowView *)pageView{
    if (!_pageView) {
        _pageView = [[NewPagedFlowView alloc] initWithFrame:CGRectMake(PageViewSafeWeight, 0, ScreenWidth - 2 * PageViewSafeWeight , ScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight)];
        _pageView.delegate = self;
        _pageView.dataSource = self;
        _pageView.minimumPageAlpha = 0.36f;
        _pageView.minimumPageScale = 0.84f;
        _pageView.isCarousel = NO;
        _pageView.orientation = NewPagedFlowViewOrientationHorizontal;
        _pageView.isOpenAutoScroll = NO;
    }
    return _pageView;
}

//加载动画 加在PageView上 两边消失的时候不会显示出来
- (UIView *)loadingView {
    if (_loadingView == nil) {
        _loadingView = [[UIView alloc] initWithFrame:CGRectMake(- ScreenWidth * 0.64, (self.pageView.height - 4) * 0.5, ScreenWidth * 0.64, 4)];
        [self.pageView addSubview:_loadingView];
    }
    return _loadingView;
}

- (UIImageView *)loadfail{
    if (_loadfail == nil) {
        _loadfail = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"loadfail"]];
        _loadfail.center = CGPointMake(self.pageView.width/2, self.pageView.height/2);
        _loadfail.userInteractionEnabled = YES;
        [_loadfail addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithActionBlock:^(id  _Nonnull sender) {
            [self loadData:[NSDate today]];
        }]];
        _loadfail.hidden = YES;
        [self.pageView addSubview:_loadfail];
    }
    return _loadfail;
}

//倒计时Label 加载self.view上
-(UILabel *)timeLabel{
    if (!_timeLabel) {
        _timeLabel = [UILabel labelWithText:@"  我的心事" fontSize:FONT_SIZE_3 frame:CGRectMake(-128, (ScreenHeight - SafeAreaTopHeight)/2, 128, 42) color:[UIColor whiteColor] textAlignment:NSTextAlignmentLeft];
        [self.view addSubview:_timeLabel];
    }
    return _timeLabel;
}

-(void)viewDidLoad{
//    self.view.backgroundColor = COLOR_NULL_4;
    
    [self.view addSubview:self.pageView];
    
    [self reloadThemeColor];
    [self loadData:[NSDate today]];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1 block:^(NSTimer * _Nonnull timer) {
        
        NSCalendar *celendar = [NSCalendar currentCalendar];//创建一个日历对象
        
        //先获取目标日期
        NSDateComponents *component = [NSDateComponents new];//日期容器
        component.year = 2018;
        component.month = 11;
        component.day = 9;
        NSDate *planDate = [celendar dateFromComponents:component];
        
        //用来得到具体的时差
        unsigned int unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond;
        
        if ([planDate compare:[NSDate date]] != NSOrderedDescending) {
            self.timeLabel.text = @"  你的名字\n         我的心事";
        }else{
            NSDateComponents *separatedDate = [celendar components:unitFlags fromDate:[NSDate date] toDate:planDate options:0];
            
            self.timeLabel.text = [NSString stringWithFormat:@"  我的心事\n  %ld时%ld分%02ld秒",separatedDate.hour,separatedDate.minute,separatedDate.second];
        }
    } repeats:YES];
    NSRunLoop *loop = [NSRunLoop currentRunLoop];
    [loop addTimer:self.timer forMode:NSRunLoopCommonModes];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self.pageView.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
    [self.timer setFireDate:[NSDate distantPast]];//设置启动时间 过去的时间 表示立即启动
    self.flag_pop = YES;
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [self.pageView.scrollView removeObserver:self forKeyPath:@"contentOffset"];
    [self.timer setFireDate:[NSDate distantFuture]];//永不启动
    
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"contentOffset"]) {
        //如果是ScrollView发生了偏移
        
        //1.当偏移超过-timeLabel的宽度的2/3且定时时间到了 可以进行跳转新页面
        
        if (self.flag_pop) {
            if (self.pageView.scrollView.contentOffset.x < -self.timeLabel.width/3*2) {
                if ([self.timeLabel.text isEqualToString:@"  你的名字\n         我的心事"]) {
                    
                    NSLog(@"进入到新页面 = %@",change[@"new"]);
                    
                    NSString *day = [NSDate dateFromDay:self.dayindex + 1];
                    
                    [self loadData:day];
                    
                }
            }
        }
        
        //2.timeLabel的动画效果 scrollView的x小于0时设置label的x为0
        UIScrollView *scrollView = object;
        
        CGRect frame = self.timeLabel.frame;
        if (scrollView.contentOffset.x >= 0) {
            if (scrollView.contentOffset.x > ScreenWidth) {
                return;
            }
            frame.origin.x = -self.timeLabel.width;
        }else{
            
            frame.origin.x = 0;
        }
        
        [UIView animateWithDuration:0.62f animations:^{
            self.timeLabel.frame = frame;
        }];
        
    }
}

- (void)reloadThemeColor {
    //加载动画颜色
    [self.loadingView setThemeBGColor];
    //加载失败颜色
    self.loadfail.image = [[UIImage imageNamed:@"loadfail"] imageByTintColor:[[AppUtills getThemeColor] colorWithAlphaComponent:0.8]];
    //加载倒计时Label的背景颜色
    self.timeLabel.backgroundColor = [[AppUtills getThemeColor] colorWithAlphaComponent:0.64];
}

-(void)loadData:(NSString *)currentdate{
    //加载未完成前不允许再加载
    self.flag_pop = NO;
    //打开加载动画,请求资源
    self.loadfail.hidden = YES;
    self.loadingView.hidden = NO;
    
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionRepeat animations:^{
        self.loadingView.left = ScreenWidth;
    } completion:nil];
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@.json",Adress_HomeRecommend,currentdate];
    
    NSLog(@"ScreenHeight = %f ScreenWidth = %f\nadress = %@",ScreenHeight,ScreenWidth,urlstr);
    [[NetworkingTool sharedManager] GET:urlstr parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        [self.datas removeAllObjects];
        
        NSDictionary *dict = responseObject;
        
        RecommendModel *dateModel = [RecommendModel modelWithDictionary:dict];
        dateModel.type = 1;
        [self.datas addObject:dateModel];
        
        NSArray *articles = dict[@"articles"];
        for (NSDictionary *subDict in articles) {
            RecommendModel *model = [RecommendModel modelWithDictionary:subDict];
            model.desc = subDict[@"description"];
            model.type = 2;
            [self.datas addObject:model];
        }
        
        [self.pageView reloadData];
        
        self.loadingView.hidden = YES;
        //加载完成 打开加载开关
        self.flag_pop = YES;
        self.dayindex ++;
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        self.loadfail.hidden = NO;
        self.loadingView.hidden = YES;
        //加载失败 打开加载开关
        self.flag_pop = YES;
    }];
    
}

#pragma mark - PagedFlowView Datasource
//返回显示View的个数
- (NSInteger)numberOfPagesInFlowView:(NewPagedFlowView *)flowView {
    return self.datas.count;
}

- (CGSize)sizeForPageInFlowView:(NewPagedFlowView *)flowView {
    CGFloat height = flowView.height - 2 * PageViewSafeHeight;
    CGFloat width = ScreenWidth - 2 * PageViewSafeWeight;
    return CGSizeMake(width, height);
}

- (UIView *)flowView:(NewPagedFlowView *)flowView cellForPageAtIndex:(NSInteger)index{
    
    PGIndexBannerSubiew *bannerView = (PGIndexBannerSubiew *)[flowView dequeueReusableCell];
    if (!bannerView) {
        CGFloat height = flowView.height - 2 * PageViewSafeHeight;
        CGFloat width = ScreenWidth - 2 * PageViewSafeWeight;
        bannerView = [[PGIndexBannerSubiew alloc] initWithFrame:CGRectMake(0, 0, width, height)];
        bannerView.backgroundColor = [UIColor whiteColor];
        bannerView.layer.masksToBounds = NO;
        bannerView.clipsToBounds = NO;
        bannerView.layer.shadowColor = COLOR_NULL_6.CGColor;
        bannerView.layer.shadowRadius = 10;
        bannerView.layer.shadowOpacity = 1;
        bannerView.layer.shadowOffset = CGSizeMake(0, 0);
        
        bannerView.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
        bannerView.mainImageView.clipsToBounds = YES;
    }
    [bannerView.mainImageView removeAllSubviews];
    
    RecommendModel *model = self.datas[index];
    if (model.type == 1) {
        
        bannerView.mainImageView.image = nil;
        
        UIView *view = [[UIView alloc] initWithFrame:bannerView.bounds];
        [bannerView.mainImageView addSubview:view];
        
        __block CGFloat pic_y = 96;
        //日
        UILabel *dayLabel = [UILabel labelWithText:[[NSDate dateFromDay:(int)index] day] fontSize:64 frame:CGRectMake(12, pic_y, 0, 0) color:[AppUtills getThemeColor] textAlignment:NSTextAlignmentLeft];
        [dayLabel sizeToFit];
        [view addSubview:dayLabel];
        
        //月
        UILabel *monthLabel = [UILabel labelWithText:[[NSDate dateFromDay:(int)index] month] fontSize:FONT_SIZE_2 frame:CGRectMake(dayLabel.right + 8, pic_y, 0, 0) color:COLOR_NULL_2 textAlignment:NSTextAlignmentLeft];
        [monthLabel sizeToFit];
        [view addSubview:monthLabel];
        
        //黑标题
        UILabel *blackTitleLabel = [UILabel labelWithText:model.title fontSize:FONT_SIZE_4 frame:CGRectMake(dayLabel.left, pic_y, 0, 0) color:COLOR_NULL_3 textAlignment:NSTextAlignmentCenter];
        [blackTitleLabel sizeToFit];
        [view addSubview:blackTitleLabel];
        
        __block CGFloat pic_height = view.height - pic_y;
        
        if(![NSData dataWithContentsOfURL:[NSURL URLWithString:model.ios_wallpaper_url]]){
            if (self.datas.count > 1) {
                RecommendModel *secondModel = self.datas[1];
                NSDictionary *notes = [secondModel.description_notes firstObject];
                model.ios_wallpaper_url = notes[@"image_url"];
            }
            
        }
        
        //背景模糊图
        UIImageView *bgPic = [UIImageView imageViewWithNetImage:model.ios_wallpaper_url frame:CGRectMake(0, pic_y, view.width, pic_height)];
        bgPic.backgroundColor = [[AppUtills getThemeColor] colorWithAlphaComponent:0.24];
        bgPic.alpha = 0.24;
        bgPic.contentMode = UIViewContentModeScaleAspectFill & UIViewContentModeBottom;
        bgPic.clipsToBounds = YES;
        [view addSubview:bgPic];
        
        __block CGFloat pic_width = pic_height * 375 / 667;
        
        //清晰图
        UIImageView *pic = [UIImageView imageViewWithNetImage:model.ios_wallpaper_url frame:CGRectMake((view.width - pic_width) * 0.5, pic_y, pic_width, pic_height)];
        pic.backgroundColor = [[AppUtills getThemeColor] colorWithAlphaComponent:0.24];
        [view addSubview:pic];
        
        pic.layer.masksToBounds = NO;
        pic.clipsToBounds = NO;
        pic.layer.shadowColor = [UIColor whiteColor].CGColor;
        pic.layer.shadowRadius = 10;
        pic.layer.shadowOpacity = 0.64;
        pic.layer.shadowOffset = CGSizeMake(0, 0);
        
        //白色标题
        UILabel *whiteTitleLabel = [UILabel labelWithText:model.title fontSize:FONT_SIZE_1 frame:CGRectMake(8, pic.height * 0.5 - 64, pic.width - 16, 24) color:[UIColor whiteColor] textAlignment:NSTextAlignmentCenter];
        whiteTitleLabel.adjustsFontSizeToFitWidth = YES;
        [pic addSubview:whiteTitleLabel];
        
        //地点
        UILabel *destinationLabel = [UILabel labelWithText:model.destination fontSize:FONT_SIZE_2 frame:CGRectMake(8, whiteTitleLabel.bottom + 8, 0, 0) color:[[UIColor whiteColor] colorWithAlphaComponent:0.84] textAlignment:NSTextAlignmentCenter];
        [destinationLabel sizeToFit];
        [destinationLabel setLeft:(pic.width - destinationLabel.width) * 0.5];
        [pic addSubview:destinationLabel];
        
        //动画
        dayLabel.alpha = monthLabel.alpha = blackTitleLabel.alpha = 0.f;
        [UIView animateWithDuration:0.64 delay:0.48 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            dayLabel.alpha = monthLabel.alpha = 1.f;
            [dayLabel setTop:12];
            [monthLabel setBottom:dayLabel.bottom - 12];
            
        } completion:nil];
        
        [UIView animateWithDuration:2.4 delay:3.6 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            whiteTitleLabel.alpha = 0.f;
            [whiteTitleLabel setTop:whiteTitleLabel.top - 48];
            
            [destinationLabel setRight:pic.width - 8];
            [destinationLabel setBottom:pic.height - 8];
            destinationLabel.font = [UIFont systemFontOfSize:FONT_SIZE_4];
            
        } completion:^(BOOL finished) {
            whiteTitleLabel.hidden = YES;
            
            [UIView animateWithDuration:0.64 animations:^{
                
                blackTitleLabel.alpha = 1.f;
                destinationLabel.backgroundColor = [[AppUtills getThemeColor] colorWithAlphaComponent:0.36];
                
                pic_y += 12;
                pic_height = view.height - pic_y;
                pic_width = pic_height * 375 / 667;
                bgPic.frame = CGRectMake(0, pic_y, view.width, pic_height);
                pic.frame = CGRectMake((view.width - pic_width) * 0.5, pic_y, pic_width, pic_height);
                
                [dayLabel setTop:4];
                [monthLabel setBottom:dayLabel.bottom - 12];
                [blackTitleLabel setTop:dayLabel.bottom - 6];
                [destinationLabel setBottom:pic.height - 8];
                
            } completion:nil];
        }];
        
        
    }else {
        
        if(![NSData dataWithContentsOfURL:[NSURL URLWithString:model.image_url]]){
            
            NSDictionary *notes = [model.description_notes firstObject];
            model.image_url = notes[@"image_url"];
        }
        
        [bannerView.mainImageView setImageURL:[NSURL URLWithString:model.image_url]];
        
        UIView *diamondView = [[UIView alloc] initWithFrame:CGRectMake(bannerView.mainImageView.width - 36, 16, 18, 18)];
        diamondView.alpha = 0.84;
        [diamondView setThemeBGColor];
        [bannerView.mainImageView addSubview:diamondView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:(CGRectMake(diamondView.left, diamondView.bottom + 8, 0, 0))];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:FONT_SIZE_2];
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.verticalText = model.title;
        [titleLabel sizeToFit];//顶部显示
        [titleLabel setWidth:diamondView.width];
        [titleLabel setGradientBGColorWithTopColor:[AppUtills getThemeColor] bottomColor:[[AppUtills getThemeColor] colorWithAlphaComponent:0.f]];
        [bannerView.mainImageView addSubview:titleLabel];
        
    }
    
    return bannerView;
}

#pragma mark - PagedFlowView Delegate
- (void)didScrollToPage:(NSInteger)pageNumber inFlowView:(NewPagedFlowView *)flowView {
}

- (void)didSelectCell:(UIView *)subView withSubViewIndex:(NSInteger)subIndex inFlowView:(NewPagedFlowView *)flowView {
    RecommendModel *model = self.datas[subIndex];
    if (model.type == 1) {
        RecommendDetailCtr *detailCtr = [RecommendDetailCtr new];
        detailCtr.img_url = model.ios_wallpaper_url;
        detailCtr.pic_title = model.title;
        detailCtr.destination = model.destination;
        [self.navigationController presentViewController:detailCtr animated:YES completion:nil];
    }
//    else {
//        RecommendArticleDetailCtr *detailCtr = [RecommendArticleDetailCtr nibCtrInitialiation];
//        detailCtr.model = model;
//        [self.navigationController pushViewController:detailCtr animated:YES];
//    }
}

- (NSURL *)smartURLForString:(NSString *)str
{
    NSURL *     result;
    NSString *  trimmedStr;
    NSRange     schemeMarkerRange;
    NSString *  scheme;
    
    assert(str != nil);
    
    result = nil;
    
    trimmedStr = [str stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    if ( (trimmedStr != nil) && (trimmedStr.length != 0) ) {
        schemeMarkerRange = [trimmedStr rangeOfString:@"://"];
        
        if (schemeMarkerRange.location == NSNotFound) {
            result = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@", trimmedStr]];
        } else {
            scheme = [trimmedStr substringWithRange:NSMakeRange(0, schemeMarkerRange.location)];
            assert(scheme != nil);
            
            if ( ([scheme compare:@"http"  options:NSCaseInsensitiveSearch] == NSOrderedSame)
                || ([scheme compare:@"https" options:NSCaseInsensitiveSearch] == NSOrderedSame) ) {
                result = [NSURL URLWithString:trimmedStr];
            } else {
                // It looks like this is some unsupported URL scheme.
            }
        }
    }
    
    return result;
}
//判断
-(void) validateUrl: (NSURL *) candidate {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:candidate];
    [request setHTTPMethod:@"HEAD"];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSLog(@"error %@",error);
        if (error) {
            NSLog(@"不可用");
        }else{
            NSLog(@"可用");
        }
    }];
    [task resume];
}


@end
