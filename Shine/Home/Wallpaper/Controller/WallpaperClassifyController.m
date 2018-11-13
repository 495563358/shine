//
//  WallpaperClassifyController.m
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallpaperClassifyController.h"
#import "WallpaperListController.h"

//Model
#import "WallpaperClassifyModel.h"
#import "WallpaperDetailModel.h"

//View
#import "WallPaperClassifyCell.h"
#import "WallClassifyHeaderView.h"

@interface WallpaperClassifyController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic,strong) UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray<WallpaperClassifyModel *> *dataArray;

@end

@implementation WallpaperClassifyController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createUI];
    [self requestData];
    // Do any additional setup after loading the view.
    
}

-(void)createUI{
    /*
     设置布局
        1、设置每个item的大小
        2、最小间隔
     */
    UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
    CGFloat itemW = (ScreenWidth - Space_CollectView * 4)/3.0;
    CGFloat itemH = itemW * 667/375;
    layout.itemSize = CGSizeMake(itemW, itemH);
    layout.sectionInset = UIEdgeInsetsMake(0, Space_CollectView, 0, 0);
    layout.minimumLineSpacing = Space_CollectView;
    layout.minimumInteritemSpacing = Space_CollectView;
    /*
     构造collectionView
     */
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight - SafeAreaBottomHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //是否显示竖直指示器
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册Cell
    [_collectionView registerNib:[UINib nibWithNibName:@"WallPaperClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"collectcell"];
    //注册header
    [_collectionView registerNib:[UINib nibWithNibName:@"WallClassifyHeaderView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"collectheader"];
    
    [self.view addSubview:_collectionView];
}

-(void)requestData{
    _dataArray = [NSMutableArray array];
    [NetworkingTool getRequest:Adress_WallpaperClassify andParagram:nil completation:^(id  _Nonnull object) {
        for (NSDictionary *dict in object) {
            WallpaperClassifyModel *classifyModel = [WallpaperClassifyModel modelWithDictionary:dict];
            
            NSMutableArray *array = [NSMutableArray array];
            for (NSDictionary *detailDict in classifyModel.thumbs) {
                WallpaperDetailModel *model = [WallpaperDetailModel modelWithDictionary:detailDict];
                [array addObject:model];
            }
            classifyModel.thumbs = array;
            
            [self.dataArray addObject:classifyModel];
        }
        [self.collectionView reloadData];
        
    } failure:^(NSError * _Nonnull error) {
        
    }];
}

#pragma mark - collectionView datasource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return _dataArray.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    WallpaperClassifyModel *model = _dataArray[section];
    return model.thumbs.count;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    return CGSizeMake(ScreenWidth, ScreenWidth*0.15);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(5, 5, 0, 5);//分别为上、左、下、右
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WallPaperClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectcell" forIndexPath:indexPath];
    WallpaperClassifyModel *model = _dataArray[indexPath.section];
    [cell setUrlImage:model.thumbs[indexPath.row]];
    return cell;
}

//headerView
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    WallClassifyHeaderView *headerview = nil;
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        headerview = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"collectheader" forIndexPath:indexPath];
        
        WallpaperClassifyModel *model = self.dataArray[indexPath.section];
        headerview.model = model;
    }
    return headerview;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    WallpaperListController *paperList = [WallpaperListController new];
    paperList.model = _dataArray[indexPath.section];
    
    CATransition *trans = [CATransition animation];
    trans.type = @"cube";//rippleEffect
    trans.subtype = kCATransitionFromRight;
    trans.duration = 1.0f;
    
    [self.navigationController.view.layer addAnimation:trans forKey:nil];
    [self.navigationController pushViewController:paperList animated:YES];
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
