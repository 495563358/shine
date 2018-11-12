//
//  WallpaperClassifyController.m
//  Shine
//
//  Created by oops on 2018/11/12.
//  Copyright © 2018 oops. All rights reserved.
//

#import "WallpaperClassifyController.h"

//Model
#import "WallpaperClassifyModel.h"
#import "WallpaperDetailModel.h"

//View
#import "WallPaperClassifyCell.h"

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
    layout.minimumLineSpacing = Space_CollectView;
    
    /*
     构造collectionView
     */
    _collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight - SafeAreaTopHeight) collectionViewLayout:layout];
    _collectionView.backgroundColor = [UIColor whiteColor];
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //是否显示竖直指示器
    _collectionView.showsVerticalScrollIndicator = NO;
    //注册Cell
    [_collectionView registerNib:[UINib nibWithNibName:@"WallPaperClassifyCell" bundle:nil] forCellWithReuseIdentifier:@"collectcell"];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    WallPaperClassifyCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectcell" forIndexPath:indexPath];
    WallpaperClassifyModel *model = _dataArray[indexPath.section];
    [cell setUrlImage:model.thumbs[indexPath.row]];
    return cell;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    NSLog(@"")
    WallpaperClassifyModel *model = self.dataArray[0];
    
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
