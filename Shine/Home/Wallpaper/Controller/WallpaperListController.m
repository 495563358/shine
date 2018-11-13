//
//  WallpaperListController.m
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallpaperListController.h"

#import "WallpaperDetailModel.h"

#import "WallPaperClassifyCell.h"

#import <MJRefresh.h>

@interface WallpaperListController ()<UICollectionViewDelegate,UICollectionViewDataSource>{
    NSInteger _currentPage;
}

@property(nonatomic,strong)UICollectionView *collectView;
@property(nonatomic,strong)NSMutableArray<WallpaperDetailModel *> *mdataArr;

@end

@implementation WallpaperListController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createUI];
    [self requestData];
    // Do any additional setup after loading the view.
    
}

-(void)createUI{
    
    NSString *labeltext = [NSString stringWithFormat:@"%@ · %@",_model.title,_model.name];
    
    UILabel *title = [UILabel labelWithText:labeltext fontSize:FONT_SIZE_2 frame:CGRectMake(0, 0, 100, 44) color:[UIColor blackColor] textAlignment:NSTextAlignmentRight];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:title];
    
    self.navigationItem.leftBarButtonItem.tintColor = [UIColor blackColor];
    
    //collectionView
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc]init];
    CGFloat itemW = (ScreenWidth - Space_CollectView * 4)/3.0;
    CGFloat itemH = itemW * 667/375;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.minimumInteritemSpacing = Space_CollectView;
    layout.sectionInset = UIEdgeInsetsMake(Space_CollectView, Space_CollectView, 0, Space_CollectView);
    
    _collectView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight) collectionViewLayout:layout];
    _collectView.delegate = self;
    _collectView.dataSource = self;
    //是否显示竖直指示器
    _collectView.showsVerticalScrollIndicator = NO;
    //注册Cell
    [_collectView registerNib:[UINib nibWithNibName:@"WallPaperClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"collectcell"];
    _collectView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_collectView];
    
    _mdataArr = [NSMutableArray array];
    _currentPage = 1;
    
    _collectView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        self->_currentPage ++;
        [self requestData];
    }];
    _collectView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self->_currentPage = 1;
        self.mdataArr = [NSMutableArray array];
        [self requestData];
        
    }];
}

-(void)requestData{
    
    NSString *urlstr = [NSString stringWithFormat:@"%@%@?page=%ld",Adress_WallpaperDetail,_model.alias,_currentPage];
    [NetworkingTool getRequest:urlstr andParagram:nil completation:^(id  _Nonnull object) {
        NSLog(@"地址 = %@\n列表详情 = %@",urlstr,object);
        if (self.collectView.mj_header.isRefreshing) {
            [self.collectView.mj_header endRefreshing];
        }
        if (self.collectView.mj_footer.isRefreshing) {
            [self.collectView.mj_footer endRefreshing];
        }
        for (NSDictionary *dict in object) {
            //最后一组数据为空 跳过
            if ([dict[@"cat"] isEqualToString:@"more"]) {
                continue;
            }
            WallpaperDetailModel *model = [WallpaperDetailModel modelWithDictionary:dict];
            [self.mdataArr addObject:model];
        }
        [self.collectView reloadData];
    } failure:^(NSError * _Nonnull error) {
        
    }];
}


#pragma mark - collectDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _mdataArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    WallPaperClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectcell" forIndexPath:indexPath];
    WallpaperDetailModel *model = _mdataArr[indexPath.row];
    [cell.urlimageView setImageURL:[NSURL URLWithString:model.thumb]];
    return cell;
}

//动画效果
- (void)collectionView:(UICollectionView *)collectionView willDisplayCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *array = collectionView.indexPathsForVisibleItems;
    if (array.count == 0)return;
    NSIndexPath *firstIndexPath = array[0];
    if (firstIndexPath.row+3 < indexPath.row) {
        CATransform3D rotation;
        rotation = CATransform3DMakeTranslation(0 ,200 ,20);//平移效果
        rotation = CATransform3DScale(rotation,0.8,0.8,1);//3D缩放效果
        rotation.m34 = 1.0/ -600;
        cell.layer.shadowColor = [[UIColor blackColor] CGColor];
        cell.layer.shadowOffset = CGSizeMake(10,10);
        cell.alpha = 0;
        cell.layer.transform = rotation;
        [UIView animateWithDuration:1.0 animations:^{
            cell.layer.transform = CATransform3DIdentity;
            cell.alpha = 1;
            cell.layer.shadowOffset = CGSizeMake(0,0);
        }];
    }
}


@end
