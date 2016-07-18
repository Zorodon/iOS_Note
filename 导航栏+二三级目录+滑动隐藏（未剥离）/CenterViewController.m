 //
//  centerViewController.m
//  BeiLu
//
//  Created by YKJ1 on 16/4/6.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "CenterViewController.h"
#import "UIViewController+MMDrawerController.h"
#import "FilterViewController.h"
#import "FDSlideBar.h"
#import "YLWContentCollectionView.h"
#import "YLWCollectionViewCell.h"
#import "ProductDetailViewController.h"
#import "CenterViewModel.h"
#import "LeftViewController.h"
#import "DealDashView.h"
#import "ShoppingSpreeView.h"
#import "OrderHistoryViewController.h"
#import "HomeViewController.h"
#import "SearchViewController.h"
#import "DealDashPopView.h"
#import "AdWebViewController.h"

#define kOptionBtnTag   900
#define kSlideBarHeight 44
#define kContentHeight kScreenHeight - 64 - kSlideBarHeight
#define contentIdentifier @"CenterViewController"
#define kDealDashDeault 800
#define kDashTime 30 //30秒抢购

@interface CenterViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UIGestureRecognizerDelegate>

@property (nonatomic, strong) YLWContentCollectionView *contentCollectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;
@property (nonatomic, strong) FilterViewController *filterViewController;
@property (nonatomic, strong) YLWCollectionViewCell *collectionViewCell;
@property (nonatomic ,strong) NSMutableArray *timerArr;

@property (nonatomic, assign) NSInteger currentTabIndex;
@property (nonatomic, assign) NSInteger dealDashIndexTag;
@property (nonatomic, assign) BOOL isOpenFilter;

@property (nonatomic, strong) NSMutableSet *btnSet;
@property (nonatomic, assign) BOOL hasOption;
@property (nonatomic, strong) NSMutableArray *optionArr;
@property (nonatomic, strong) NSMutableArray *optionSArr;

@property (nonatomic, strong) UIButton *filterBtn;
@property (nonatomic, strong) UIButton *searchBtn;
@property (nonatomic, strong) UIView *filterView;
@property (nonatomic, strong) UIScrollView *filterScrollView;
@property (nonatomic, strong) ShoppingSpreeView *spreeView;
@property (nonatomic, strong) DealDashView *startDealView;
@property (nonatomic, strong) DealDashView *endDealView;
@property (nonatomic, strong) NSMutableArray *categoryfilter;//商品筛选
@property (nonatomic, strong) NSMutableArray *selectFilter;//选中的筛选条件

@property (nonatomic, strong) UIPanGestureRecognizer *panGesture;
@property (nonatomic, assign) CGFloat lastContentOffset;

@property (nonatomic, assign) BOOL isDealDash; //是否开始冲刺
@property (nonatomic, assign) BOOL isSpree;  //是否进入冲刺
@property (nonatomic, assign) BOOL isStartDash;  //显示倒计时
@property (nonatomic, assign) BOOL isDealDashShow;  //原来有倒计时界面的先隐藏后显示标志

@property (nonatomic, assign) NSInteger hGoing;
@property (nonatomic, assign) NSInteger hLeft;

@property (nonatomic, strong) FDSlideBar *slideBar;
@property (nonatomic, strong) FDSlideBar *secondSlideBar;//二级目录
@property (nonatomic, strong) FDSlideBar *thirdSlideBar;//三级目录
@property (nonatomic, strong) UIView *categoryPathView;//目录路径界面
@property (nonatomic, strong) UILabel *categoryPathLabel;

@property (nonatomic, strong) NSMutableArray *firstCategory;//商品名称
@property (nonatomic, strong) NSMutableArray *secondCategory;//二三级目录name数组
@property (nonatomic, strong) NSMutableArray *thirdCategory;
@property (nonatomic, strong) NSMutableArray *firstIdCategory;//商品ID
@property (nonatomic, strong) NSMutableArray *secondIdCategory;//二三级目录id数组
@property (nonatomic, strong) NSMutableArray *thirdIdCategory;

//原始商品名称目录
@property (nonatomic, strong) NSMutableArray *firstAllCategory;
@property (nonatomic, strong) NSMutableArray *secondAllCategory;
@property (nonatomic, strong) NSMutableArray *thirdAllCategory;
@property (nonatomic, strong) NSMutableArray *firstIdAllCategory;
@property (nonatomic, strong) NSMutableArray *secondIdAllCategory;
@property (nonatomic, strong) NSMutableArray *thirdIdAllCategory;

@property (nonatomic, assign) NSInteger secondIndex;//二三级标志
@property (nonatomic, assign) NSInteger thirdIndex;
@property (nonatomic, strong) UIButton *secondBtn;
@property (nonatomic, strong) UIButton *thirdBtn;
@property (nonatomic, strong) UIImageView *secondImageView;
@property (nonatomic, strong) UIImageView *thirdImageView;
@property (nonatomic, strong) UIView *indexView;

//定时30显示是否可以抢购
@property (nonatomic, strong) NSTimer *dashTimer;
@property (nonatomic, assign) NSInteger dashTime;
@property (nonatomic, assign) BOOL isSelectYes;
@property (nonatomic, strong) DealDashPopView *dealDashPopView;

@end

@implementation CenterViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavigationBar];
    [self initData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToOrderHistoryViewController:) name:kPushAllOrderNotification object:nil];

    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id=[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    //保存手机的相关信息
    [self postSavePhone];
    
    if (0==customer_id.length || 0==token.length){
        [self postCategories];
    }else{
        [self postDealdash];
    }

}

- (void)initData{
    self.categoryfilter = [NSMutableArray array];
    self.optionSArr = [NSMutableArray array];
    self.selectFilter = [NSMutableArray array];
    
    self.firstCategory = [NSMutableArray array];
    self.firstIdCategory= [NSMutableArray array];
    self.secondCategory = [NSMutableArray array];
    self.secondIdCategory = [NSMutableArray array];
    self.thirdCategory = [NSMutableArray array];
    self.thirdIdCategory = [NSMutableArray array];
    
    self.firstAllCategory = [NSMutableArray array];
    self.firstIdAllCategory= [NSMutableArray array];
    self.secondAllCategory = [NSMutableArray array];
    self.secondIdAllCategory = [NSMutableArray array];
    self.thirdAllCategory = [NSMutableArray array];
    self.thirdIdAllCategory = [NSMutableArray array];
    
    self.dealDashIndexTag = kDealDashDeault;
    self.filterBtn.hidden = YES;
    
    self.isSpree = NO;
    self.isDealDash = NO;
    self.isStartDash = NO;
    self.isDealDashShow = NO;
    self.secondIndex = -1;
    self.thirdIndex = -1;
    
}

- (void)initNavigationBar {
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                           NSFontAttributeName:[UIFont boldSystemFontOfSize:16]
                                                           }];
    [UINavigationBar appearance].barTintColor = kMainColor;
    [UINavigationBar appearance].translucent = NO;
    [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
    
    NSString *imagname;
    NSUserDefaults *ssd = [NSUserDefaults standardUserDefaults];
    NSNumber *logoshow = [ssd objectForKey:@"LogoShow"];
    if ([logoshow integerValue] == 1){
        imagname = @"logo21";
    }else{
        imagname = @"logo2";
    }
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imagname]];
    self.navigationItem.titleView = imageView;
    
    self.filterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.filterBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
    [self.filterBtn addTarget:self action:@selector(filterAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.filterBtn setFrame:CGRectMake(0, 0, 16, 16)];
    self.filterBtn.imageView.contentMode = UIViewContentModeScaleToFill;
    UIBarButtonItem *filterItem = [[UIBarButtonItem alloc]initWithCustomView:self.filterBtn];
    
    self.searchBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.searchBtn addTarget:self action:@selector(searchAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.searchBtn setFrame:CGRectMake(0, 0, 16, 16)];
    UIBarButtonItem *searchItem = [[UIBarButtonItem alloc]initWithCustomView:self.searchBtn];
    
    UIBarButtonItem *spaceItem1 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem1.width = 5;
    UIBarButtonItem *spaceItem2 = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
    spaceItem2.width = 20;
    self.navigationItem.rightBarButtonItems = @[spaceItem1,searchItem,spaceItem2,filterItem];
    
    UIButton *leftDrawerBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [leftDrawerBtn setImage:[UIImage imageNamed:@"side"] forState:UIControlStateNormal];
    [leftDrawerBtn addTarget:self action:@selector(leftItemAction) forControlEvents:UIControlEventTouchUpInside];
    [leftDrawerBtn setFrame:CGRectMake(0, 0, 30, 30)];
    UIBarButtonItem *leftDrawerItem = [[UIBarButtonItem alloc]initWithCustomView:leftDrawerBtn];
    
    self.navigationItem.leftBarButtonItem = leftDrawerItem;
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToDetailViewController:) name:kPushDetailProductNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToHomeDetailViewController:) name:kPushHomeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToCategoryViewController:) name:kMoveToCategoryNotification object:nil];

    [self.dashTimer setFireDate:[NSDate date]];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kPushDetailProductNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kPushHomeNotification object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMoveToCategoryNotification object:nil];
    [self.dashTimer setFireDate:[NSDate distantFuture]];
}

- (NSMutableArray *)timerArr{
    if (!_timerArr) {
        _timerArr = [NSMutableArray array];
    }
    return _timerArr;
}

-(UICollectionViewFlowLayout *)flowLayout{
    if (_flowLayout == nil) {
        _flowLayout = [[UICollectionViewFlowLayout alloc]init];
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    }
    return  _flowLayout;
}
-(YLWContentCollectionView *)contentCollectionView{
    if (_contentCollectionView == nil) {
        _contentCollectionView = [[YLWContentCollectionView alloc]initWithFrame:CGRectMake(0, kSlideBarHeight, kScreenWidth, kContentHeight) collectionViewLayout:self.flowLayout];
        _contentCollectionView.delegate = self;
        _contentCollectionView.dataSource = self;
        _contentCollectionView.pagingEnabled = YES;
        _contentCollectionView.bounces = NO;
        _contentCollectionView.showsHorizontalScrollIndicator = NO;
//        for (int i = 0; i <self.firstCategory.count; i ++) {
//            [_contentCollectionView registerClass:[YLWCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,i]];
//        }
        
        self.panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
        [self.panGesture setMaximumNumberOfTouches:1];
        [self.panGesture setDelegate:self];
        [_contentCollectionView addGestureRecognizer:self.panGesture];
    }
    return _contentCollectionView;
}

- (NSMutableArray *)optionArr {
    if (!_optionArr) {
        _optionArr = [NSMutableArray array];
        NSArray *array = [NSArray array];
        for (int i=0; i<self.firstCategory.count; i++) {
            [_optionArr addObject:array];
        }
    }
    return _optionArr;
}
- (UIView *)filterView {
    if (!_filterView) {
        _filterView = [[UIView alloc] initWithFrame:CGRectMake(0, kSlideBarHeight, kScreenWidth, kSlideBarHeight)];
        _filterView.backgroundColor = [UIColor whiteColor];
        [self.view addSubview:_filterView];
    }
    return _filterView;
}
- (UIScrollView *)filterScrollView {
    if (!_filterScrollView) {
//        _filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0,0,kScreenWidth,kSlideBarHeight)];
        _filterScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(100,0,kScreenWidth-100,kSlideBarHeight)];
        _filterScrollView.backgroundColor = bGroundColorW;
        _filterScrollView.showsHorizontalScrollIndicator = NO;
        _filterScrollView.showsVerticalScrollIndicator = NO;
        [self.filterView addSubview:_filterScrollView];
    }
    return _filterScrollView;
}

- (NSMutableSet *)btnSet {
    if (!_btnSet) {
        _btnSet = [NSMutableSet set];
    }
    return _btnSet;
}

- (void)initEdgeView {
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, self.view.frame.size.height)];
    leftView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:leftView];
    [self.view bringSubviewToFront:leftView];
    
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth-10,0, 10, self.view.frame.size.height)];
    rightView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:rightView];
    [self.view bringSubviewToFront:rightView];
}
//初始化主界面显示筛选条件
- (void)initScrollViewWithContent:(NSArray *)array {
    for (UIView *view in self.filterScrollView.subviews) {
        [view removeFromSuperview];
    }
    CGFloat sum=0.0f;
    for (int i=0; i<array.count; i++) {
        NSString *str = array[i];
        UIFont *font = [UIFont systemFontOfSize:12];
        NSDictionary * tDic = @{NSFontAttributeName:font};
        CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 30)
                                        options:NSStringDrawingUsesLineFragmentOrigin
                                     attributes:tDic
                                        context:nil];
        
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.tag = kOptionBtnTag + i;
        btn.titleLabel.font = font;
        [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [btn setTitle:str forState:UIControlStateNormal];
        btn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
        
        btn.backgroundColor = UIColorWithRGBA(242, 242, 242, 1);
        btn.layer.cornerRadius = 7;
        [self.filterScrollView addSubview:btn];
        [self.btnSet addObject:btn];
        
        [btn addTarget:self action:@selector(deleteAction:) forControlEvents:UIControlEventTouchUpInside];
        
        CGFloat width = rect.size.width+40>60?rect.size.width+40:60;
        btn.frame = CGRectMake(10 + sum, 7, width, 33);
        
        UIImageView *deleteImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
        deleteImageV.image = [UIImage imageNamed:@"cancel2"] ;
        [self.filterScrollView addSubview:deleteImageV];
        deleteImageV.center = CGPointMake(sum+width-5, btn.center.y);
        
        sum += width+10;
        
    }
    
    //清除全部
    UIButton *cBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    [cBtn setTitleColor:UIColorWithRGBA(220, 72, 60, 1) forState:UIControlStateNormal];
    [cBtn setTitle:ZDLocalizedString(@"ClearAll", nil) forState:UIControlStateNormal];
    cBtn.titleEdgeInsets = UIEdgeInsetsMake(0, -15, 0, 0);
    cBtn.backgroundColor = UIColorWithRGBA(242, 242, 242, 1);
    cBtn.layer.cornerRadius = 7;
    CGFloat cWidth = 85;
    cBtn.frame = CGRectMake(10, 7, cWidth, 33);
    [self.filterView addSubview:cBtn];
    [cBtn addTarget:self action:@selector(deleteAllAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *deleteImageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 12, 12)];
    deleteImageV.image = [[UIImage imageNamed:@"cancel2"] imageWithColor:UIColorWithRGBA(220, 72, 60, 1)];
    [self.filterView addSubview:deleteImageV];
    deleteImageV.center = CGPointMake(cWidth, cBtn.center.y);
    
    self.filterScrollView.contentSize = CGSizeMake(sum+20, kSlideBarHeight);
    self.filterScrollView.contentOffset = CGPointMake(0, 0);
    if (self.btnSet.count!=0) {
        self.filterView.hidden = NO;
        self.hasOption = YES;
    }else{
        self.filterView.hidden = YES;
        self.hasOption = NO;
    }
}

- (FilterViewController *)filterViewController {
    if (!_filterViewController) {
        _filterViewController = [[FilterViewController alloc] init];

        __weak typeof(CenterViewController *)weakSelf = self;
        _filterViewController.applyBlock = ^(NSArray *options){
            __strong typeof(CenterViewController *)strongSelf = weakSelf;
            [strongSelf closeFilter];
            [strongSelf.filterBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
            [strongSelf.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            strongSelf.isOpenFilter = NO;
            strongSelf.optionArr[strongSelf.currentTabIndex] = [NSMutableArray arrayWithArray:options];
            //商品显示界面传值
            [strongSelf setProductId:strongSelf.currentTabIndex];
           
        };
        [self.view insertSubview:_filterViewController.view belowSubview:self.slideBar];
        [self addChildViewController:_filterViewController];
    }
    return _filterViewController;
}

- (void)initSlideBar {
    [self.slideBar removeFromSuperview];
    self.slideBar = nil;
    
    self.slideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kSlideBarHeight)];
    self.slideBar.backgroundColor = kMainColor;
    self.slideBar.itemsTitle = self.firstCategory;
    self.slideBar.itemColor = UIColorWithRGBA(76, 76, 76, 1);
    self.slideBar.itemSelectedColor = UIColorWithRGBA(17, 17, 17, 1);
    self.slideBar.sliderColor = UIColorWithRGBA(17, 17, 17, 1);
    self.slideBar.itemBackgroundColor = UIColorWithRGBA(242, 242, 242, 1);
    
    [self.slideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        [self.contentCollectionView setContentOffset:CGPointMake(idx *self.contentCollectionView.bounds.size.width, 0) animated:NO];
        self.currentTabIndex = idx;
        self.secondIndex = -1;
        self.thirdIndex = -1;

        //筛选按键隐藏显示
        [self filterBtnHidden:self.currentTabIndex];
        //删除倒计时
        if (self.currentTabIndex!=self.dealDashIndexTag) {
            [self deleteTimer];
        }else {
            //读取抢购时间
            [self postDealdash];
        }
        //冲刺
        [self setupShoppingSpree];
        //显示隐藏选项卡
        [self toggleSlider];
    
        //二级目录
        [self hideSlideBar];
        if (self.secondCategory[idx] && ((NSArray *)self.secondCategory[idx]).count>0) {
            [self initSecondSlideBar];
        }
        
        int homeid = [self.firstIdCategory[self.currentTabIndex] intValue];
        
        if (self.currentTabIndex !=self.dealDashIndexTag) {
            if (self.currentTabIndex!=0) {
                [self setupFilterScrollView];
            }else{
                if (homeid>=0) {
                    [self setupFilterScrollView];
                }
            }
        }
        
        //点击改变整个页面大小
        if (self.currentTabIndex==0 && homeid < 0) {
            self.filterView.hidden = YES;
            self.hasOption = NO;
            [self.contentCollectionView.collectionViewLayout invalidateLayout];
            self.contentCollectionView.frame = CGRectMake(0, 0, kScreenWidth, kContentHeight+kSlideBarHeight);
        }else{
            [self.contentCollectionView.collectionViewLayout invalidateLayout];
            self.contentCollectionView.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth, kContentHeight);
        }

    }];
    [self.view addSubview:self.slideBar];
    
    //二级目录
    if (self.secondCategory.count > 0){
        if (self.secondCategory[0] && ((NSArray *)self.secondCategory[0]).count>0) {
            [self initSecondSlideBar];
        }
    }

    self.categoryPathView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kSlideBarHeight)];
    self.categoryPathView.backgroundColor = UIColorWithRGBA(242, 242, 242, 1);
    self.categoryPathLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, kScreenWidth, kSlideBarHeight)];
    self.categoryPathLabel.font = [UIFont boldSystemFontOfSize:13];
    [self.slideBar addSubview:self.categoryPathView];
    [self.categoryPathView addSubview:self.categoryPathLabel];
    self.categoryPathView.hidden = YES;
    
    self.secondBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.secondBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.2];
    [self.categoryPathView addSubview:self.secondBtn];
    [self.secondBtn addTarget:self action:@selector(showSecondCategoryView) forControlEvents:UIControlEventTouchUpInside];
    
    self.thirdBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.thirdBtn.backgroundColor = [UIColor colorWithWhite:0 alpha:0.4];
    [self.categoryPathView addSubview:self.thirdBtn];
    [self.thirdBtn addTarget:self action:@selector(showThirdCategoryView) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"return"]];
    self.thirdImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"return"]];
    [self.categoryPathView addSubview:self.secondImageView];
    [self.categoryPathView addSubview:self.thirdImageView];
    
    self.indexView= [[UIView alloc]init];
    self.indexView.frame = CGRectMake(0, kSlideBarHeight-3, 0, 3);
    self.indexView.backgroundColor = [UIColor colorWithRed:220/255.0 green:72/255.0 blue:60/255.0 alpha:1.0];
    [self.categoryPathView addSubview:self.indexView];

}
//显示二级目录
- (void)showSecondCategoryView {
    if (self.thirdIndex!=-1) {
        [self sortThirdCategory];
    }
    if(self.secondIndex!=-1){
        [self sortSecondCategory];
    }
    self.secondIndex = -1;
    self.indexView.frame = CGRectMake(0, kSlideBarHeight-3, 0, 3);
    self.categoryPathView.hidden = YES;
    [self.thirdSlideBar removeFromSuperview];
    if (self.secondCategory[self.currentTabIndex] && ((NSArray *)self.secondCategory[self.currentTabIndex]).count>0) {
        [self initSecondSlideBar];
    }
    //temp 一级目录网络请求
    [self setProductId:self.currentTabIndex];
}
//显示三级目录
- (void)showThirdCategoryView {
    if (self.thirdIndex!=-1) {
        [self sortThirdCategory];
    }
    self.thirdIndex = -1;
    [self showCategoryView];
    if (self.thirdCategory[self.currentTabIndex][self.secondIndex] && ((NSArray *)self.thirdCategory[self.currentTabIndex][self.secondIndex]).count>0) {
        [self initThirdSlideBar];
    }
}
//重新排序二级目录
- (void)sortSecondCategory {
    //重新排序 点击放到第一位
    NSMutableArray *tempNameArr = self.secondCategory[self.currentTabIndex];
    NSMutableArray *tempIdArr = self.secondIdCategory[self.currentTabIndex];
    NSString *tempName = tempNameArr[self.secondIndex];
    NSString *tempId = tempIdArr[self.secondIndex];
    [tempNameArr removeObjectAtIndex:self.secondIndex];
    [tempIdArr removeObjectAtIndex:self.secondIndex];
    [tempNameArr insertObject:tempName atIndex:0];
    [tempIdArr insertObject:tempId atIndex:0];
    self.secondCategory[self.currentTabIndex] = tempNameArr;
    self.secondIdCategory[self.currentTabIndex] = tempIdArr;
    
    NSMutableArray *tempNameArr1 = self.thirdCategory[self.currentTabIndex];
    NSMutableArray *tempIdArr1 = self.thirdIdCategory[self.currentTabIndex];
    NSMutableArray *temp1 = self.thirdCategory[self.currentTabIndex][self.secondIndex];
    NSMutableArray *tempId1 = self.thirdIdCategory[self.currentTabIndex][self.secondIndex];
    [tempNameArr1 removeObjectAtIndex:self.secondIndex];
    [tempIdArr1 removeObjectAtIndex:self.secondIndex];
    [tempNameArr1 insertObject:temp1 atIndex:0];
    [tempIdArr1 insertObject:tempId1 atIndex:0];
}
//重新排序三级目录
- (void)sortThirdCategory {
    //重新排序 点击放到第一位
    NSMutableArray *tempNameArr2 = self.thirdCategory[self.currentTabIndex][self.secondIndex];
    NSMutableArray *tempIdArr2 = self.thirdIdCategory[self.currentTabIndex][self.secondIndex];
    NSString *tempName2 = tempNameArr2[self.thirdIndex];
    NSString *tempId2 = tempIdArr2[self.thirdIndex];
    [tempNameArr2 removeObjectAtIndex:self.thirdIndex];
    [tempIdArr2 removeObjectAtIndex:self.thirdIndex];
    [tempNameArr2 insertObject:tempName2 atIndex:0];
    [tempIdArr2 insertObject:tempId2 atIndex:0];
    self.thirdCategory[self.currentTabIndex][self.secondIndex] = tempNameArr2;
    self.thirdIdCategory[self.currentTabIndex][self.secondIndex] = tempIdArr2;
}

//显示目录路径
- (void)showCategoryView {
    self.categoryPathView.hidden = NO;
    
    CGSize size = CGSizeMake(MAXFLOAT,kSlideBarHeight);
    NSDictionary *attributes = @{NSFontAttributeName: self.categoryPathLabel.font};
    
    NSString *second = @"";
    NSString *third = @"";
    
    NSArray *secondArr = self.secondCategory[self.currentTabIndex];
    if (secondArr.count>0 && self.secondIndex < secondArr.count && self.secondIndex!=-1) {
        CGRect rect1 = [self.firstCategory[self.currentTabIndex] boundingRectWithSize:size
                                                                             options:NSStringDrawingUsesLineFragmentOrigin
                                                                          attributes:attributes
                                                                             context:nil];
        CGRect rect2 = [self.secondCategory[self.currentTabIndex][self.secondIndex] boundingRectWithSize:size
                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
                                                                                              attributes:attributes
                                                                                                 context:nil];
        self.secondBtn.frame = CGRectMake(10, 0, rect1.size.width+10, kSlideBarHeight);

//        if (self.secondIndex!=-1 && self.secondIndex < secondArr.count) {
            second = [NSString stringWithFormat:@"%@",secondArr[self.secondIndex]];
            self.secondImageView.frame = CGRectMake(10+rect1.size.width+10, 15, 7, 12);
            self.secondImageView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.indexView.frame = CGRectMake(10+rect1.size.width+10+10, kSlideBarHeight-3, rect2.size.width, 3);
            }];
        
//        }else{
//            self.secondImageView.hidden = YES;
//        }
        
        
        NSArray *thirdArr = self.thirdCategory[self.currentTabIndex][self.secondIndex];
        if (thirdArr.count>0 && self.secondIndex < secondArr.count && self.thirdIndex < thirdArr.count && self.thirdIndex!=-1) {
            CGRect rect1 = [self.firstCategory[self.currentTabIndex] boundingRectWithSize:size
                                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                                               attributes:attributes
                                                                                  context:nil];
            CGRect rect2 = [self.secondCategory[self.currentTabIndex][self.secondIndex] boundingRectWithSize:size
                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                  attributes:attributes
                                                                                                     context:nil];
            
            self.thirdBtn.frame = CGRectMake(10+rect1.size.width+10+5, 0, rect2.size.width+10, kSlideBarHeight);
            
            //        if (self.thirdIndex!=-1 && self.thirdIndex < thirdArr.count) {
            CGRect rect3 = [self.thirdCategory[self.currentTabIndex][self.secondIndex][self.thirdIndex] boundingRectWithSize:size
                                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
                                                                                                                  attributes:attributes
                                                                                                                     context:nil];
            
            third = [NSString stringWithFormat:@"%@",thirdArr[self.thirdIndex]];
            self.thirdImageView.frame = CGRectMake(10+rect1.size.width+10+rect2.size.width+15, 15, 7,12);
            self.thirdImageView.hidden = NO;
            [UIView animateWithDuration:0.3 animations:^{
                self.indexView.frame = CGRectMake(10+rect1.size.width+10+rect2.size.width+26, kSlideBarHeight-3, rect3.size.width, 3);
            }];
            //        }else{
            //            self.thirdImageView.hidden = YES;
            //        }
            
        }else{
            self.thirdBtn.frame = CGRectZero;
            self.thirdImageView.hidden = YES;
        }
        
    }else{
        self.secondBtn.frame = CGRectZero;
        self.secondImageView.hidden = YES;
    }
    
//    NSArray *thirdArr = self.thirdCategory[self.currentTabIndex][self.secondIndex];
//    if (thirdArr.count>0 && self.secondIndex < secondArr.count && self.thirdIndex < thirdArr.count && self.thirdIndex!=-1) {
//        CGRect rect1 = [self.firstCategory[self.currentTabIndex] boundingRectWithSize:size
//                                                                             options:NSStringDrawingUsesLineFragmentOrigin
//                                                                          attributes:attributes
//                                                                             context:nil];
//        CGRect rect2 = [self.secondCategory[self.currentTabIndex][self.secondIndex] boundingRectWithSize:size
//                                                                                                 options:NSStringDrawingUsesLineFragmentOrigin
//                                                                                              attributes:attributes
//                                                                                                 context:nil];
//        
//        self.thirdBtn.frame = CGRectMake(10+rect1.size.width+10+5, 0, rect2.size.width+10, kSlideBarHeight);
//
////        if (self.thirdIndex!=-1 && self.thirdIndex < thirdArr.count) {
//            CGRect rect3 = [self.thirdCategory[self.currentTabIndex][self.secondIndex][self.thirdIndex] boundingRectWithSize:size
//                                                                                                                     options:NSStringDrawingUsesLineFragmentOrigin
//                                                                                                                  attributes:attributes
//                                                                                                                     context:nil];
//            
//            third = [NSString stringWithFormat:@"%@",thirdArr[self.thirdIndex]];
//            self.thirdImageView.frame = CGRectMake(10+rect1.size.width+10+rect2.size.width+15, 15, 7,12);
//            self.thirdImageView.hidden = NO;
//            [UIView animateWithDuration:0.3 animations:^{
//                self.indexView.frame = CGRectMake(10+rect1.size.width+10+rect2.size.width+26, kSlideBarHeight-3, rect3.size.width, 3);
//            }];
////        }else{
////            self.thirdImageView.hidden = YES;
////        }
//
//    }else{
//        self.thirdBtn.frame = CGRectZero;
//        self.thirdImageView.hidden = YES;
//    }
    

    NSMutableAttributedString *string;
    if (![third isEqualToString:@""]) {
        string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    %@    %@",self.firstCategory[self.currentTabIndex],second,third]];
        NSRange range = NSMakeRange(string.length-third.length,third.length);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:220/255.0 green:72/255.0 blue:60/255.0 alpha:1.0] range:range];
    }else if(![second isEqualToString:@""]){
        string = [[NSMutableAttributedString alloc]initWithString:[NSString stringWithFormat:@"%@    %@",self.firstCategory[self.currentTabIndex],second]];
        NSRange range = NSMakeRange(string.length-second.length,second.length);
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithRed:220/255.0 green:72/255.0 blue:60/255.0 alpha:1.0] range:range];
    }
    
    self.categoryPathLabel.attributedText = string;
    
    //temp 网络请求
    [self setProductId:self.currentTabIndex];

}

- (void)initSecondSlideBar{
    [self.secondSlideBar removeFromSuperview];
    self.secondSlideBar = nil;
    
    self.secondSlideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kSlideBarHeight-6)];
    self.secondSlideBar.backgroundColor = kMainColor;
    self.secondSlideBar.itemsTitle = self.secondCategory[self.currentTabIndex];

    self.secondSlideBar.itemColor = UIColorWithRGBA(76, 76, 76, 1);
    self.secondSlideBar.itemSelectedColor = UIColorWithRGBA(76, 76, 76, 1);
    self.secondSlideBar.sliderColor = UIColorWithRGBA(235, 235, 235, 1);
    self.secondSlideBar.itemBackgroundColor = UIColorWithRGBA(235, 235, 235, 1);
    [self.view addSubview:self.secondSlideBar];
    [self.view bringSubviewToFront:self.slideBar];
    
     [UIView animateWithDuration:0.3 animations:^{
         self.secondSlideBar.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth,kSlideBarHeight-6);
     }];
    
    [self.secondSlideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        self.secondSlideBar.sliderColor = UIColorWithRGBA(17, 17, 17, 1);
        self.secondIndex = idx;
        self.thirdIndex = -1;
        [self.view bringSubviewToFront:self.secondSlideBar];
        [UIView animateWithDuration:0.3 animations:^{
            self.secondSlideBar.frame = CGRectMake(0, 0, kScreenWidth,kSlideBarHeight-6);
            self.secondSlideBar.alpha = 0;
        } completion:^(BOOL finished) {
            [self.secondSlideBar removeFromSuperview];
   
            if (self.currentTabIndex < self.secondCategory.count){
                [self showCategoryView];
            }

            if (self.thirdCategory[self.currentTabIndex][idx] && ((NSArray *)self.thirdCategory[self.currentTabIndex][idx]).count>0) {
                [self initThirdSlideBar];
            }

        }];
    
    }];
}

- (void)initThirdSlideBar {
    [self.thirdSlideBar removeFromSuperview];
    self.thirdSlideBar = nil;
    
    self.thirdSlideBar = [[FDSlideBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kSlideBarHeight-6)];
    self.thirdSlideBar.backgroundColor = kMainColor;
    self.thirdSlideBar.itemsTitle = self.thirdCategory[self.currentTabIndex][self.secondIndex];
    
    self.thirdSlideBar.itemColor = UIColorWithRGBA(76, 76, 76, 1);
    self.thirdSlideBar.itemSelectedColor = UIColorWithRGBA(76, 76, 76, 1);
    self.thirdSlideBar.sliderColor = UIColorWithRGBA(235, 235, 235, 1);
    self.thirdSlideBar.itemBackgroundColor = UIColorWithRGBA(235, 235, 235, 1);
    [self.view addSubview:self.thirdSlideBar];
    [self.view bringSubviewToFront:self.slideBar];

    [UIView animateWithDuration:0.3 animations:^{
        self.thirdSlideBar.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth,kSlideBarHeight-6);
    }];
    
    [self.thirdSlideBar slideBarItemSelectedCallback:^(NSUInteger idx) {
        self.thirdSlideBar.sliderColor = UIColorWithRGBA(17, 17, 17, 1);
        self.thirdIndex = idx;
        [self.view bringSubviewToFront:self.thirdSlideBar];
        [UIView animateWithDuration:0.3 animations:^{
            self.thirdSlideBar.frame = CGRectMake(0, 0, kScreenWidth,kSlideBarHeight-6);
            self.thirdSlideBar.alpha = 0;
        } completion:^(BOOL finished) {
            [self.thirdSlideBar removeFromSuperview];
            [self showCategoryView];

        }];
        
    }];
}

- (void)hideSlideBar {
    [self.secondSlideBar removeFromSuperview];
    [self.thirdSlideBar removeFromSuperview];
    self.indexView.frame = CGRectMake(0, kSlideBarHeight-3, 0, 3);

}

//进入界面一定时间后弹出窗口，显示抢购标签
- (void)dashTimerAction {

    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    if (self.mm_drawerController.visibleLeftDrawerWidth==0&&self.mm_drawerController.visibleRightDrawerWidth==0&&[nav.visibleViewController isKindOfClass:[CenterViewController class]]) {

        self.dashTime++;
        if (self.dashTime==kDashTime) {
            [self.dashTimer setFireDate:[NSDate distantFuture]];
            
            DealDashPopView *dealDashPopView = [[DealDashPopView alloc] init];
            [dealDashPopView showPopView];
            dealDashPopView.yesBlock = ^{
                self.isSelectYes = YES;
                
                self.secondIndex = -1;
                self.thirdIndex = -1;
                [self.secondSlideBar removeFromSuperview];
                [self.thirdSlideBar removeFromSuperview];
                
                [self toggleDealDash:NO];
                [self initSlideBar];
                [self.slideBar selectSlideBarItemAtIndex:self.dealDashIndexTag];
//                [self.contentCollectionView reloadData];
                [self.contentCollectionView setContentOffset:CGPointMake(self.dealDashIndexTag *self.contentCollectionView.bounds.size.width, 0) animated:NO];
                [self postDealdash];
                //取消定时
                [self.dashTimer invalidate];
                self.dashTimer = nil;
            };
            dealDashPopView.noBlock = ^{
                //取消定时
                [self.dashTimer invalidate];
                self.dashTimer = nil;
            };
            

//                else{
//                    [self toggleDealDash:NO];
//                    [self initSlideBar];
//                    if (self.currentTabIndex>=self.dealDashIndexTag) {
//                        self.currentTabIndex++;
//                    }
//                    if (self.secondIndex!=-1) {
//                        [self showCategoryView];
//                    }
//
//                    [self.contentCollectionView reloadData];
//                    [self.slideBar selectSlideBarItemAtIndex:self.currentTabIndex];
//                    [self.contentCollectionView setContentOffset:CGPointMake(self.currentTabIndex*self.contentCollectionView.bounds.size.width, 0) animated:NO];
//                }
//                
//                //记录点击时间，一天内不在显示
//                NSUserDefaults *ud = [NSUserDefaults standardUserDefaults];
//                NSDate *nowDate = [NSDate date];
//                [ud setObject:@([nowDate timeIntervalSince1970]) forKey:@"dealdashtime"];
//                [ud synchronize];
                
//            };
        }
    }
    
}


//目录结构调整，隐藏抢购的各级目录
- (void)toggleDealDash:(BOOL )toggle {
    self.firstCategory = [self.firstAllCategory mutableCopy];
    self.firstIdCategory = [self.firstIdAllCategory mutableCopy];
    self.secondCategory = [self.secondAllCategory mutableCopy];
    self.secondIdCategory = [self.secondIdAllCategory mutableCopy];
    self.thirdCategory = [self.thirdAllCategory mutableCopy];
    self.thirdIdCategory = [self.thirdIdAllCategory mutableCopy];
    
    if (toggle) {
        if (self.dealDashIndexTag!=kDealDashDeault) {
            [self.firstCategory removeObjectAtIndex:self.dealDashIndexTag];
            [self.firstIdCategory removeObjectAtIndex:self.dealDashIndexTag];
            [self.secondCategory removeObjectAtIndex:self.dealDashIndexTag];
            [self.secondIdCategory removeObjectAtIndex:self.dealDashIndexTag];
            [self.thirdCategory removeObjectAtIndex:self.dealDashIndexTag];
            [self.thirdIdCategory removeObjectAtIndex:self.dealDashIndexTag];
            
            [self.categoryfilter removeObjectAtIndex:self.dealDashIndexTag];
            self.dealDashIndexTag = kDealDashDeault;
            self.isDealDashShow = YES;
        }
    }else{
        for (int i=0;i<self.firstAllCategory.count;i++) {
            NSString *str = self.firstAllCategory[i];
            if ([str hasSuffix:@".png"]&&self.isDealDashShow) {
                self.dealDashIndexTag = i;
                [self.optionArr insertObject:@[] atIndex:self.dealDashIndexTag];
                [self.categoryfilter insertObject:@[] atIndex:self.dealDashIndexTag];
                break;
            }
        }
    }
}


#pragma mark - UIScrollViewDelegate
//屏幕滑动时
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.panGesture.enabled = NO;
    self.categoryPathView.hidden = YES;
    [self hideSlideBar];
    if (self.thirdIndex!=-1) {
        [self sortThirdCategory];
    }
    if(self.secondIndex!=-1){
        [self sortSecondCategory];
    }

    self.secondIndex = -1;
    self.thirdIndex = -1;
    
    int homeid = 0;
    if (0 < self.firstCategory.count){
        homeid = [self.firstIdCategory[0] intValue];
    }
    if (self.currentTabIndex<2 && homeid == -1) {
        self.filterView.hidden = YES;

        [self.contentCollectionView.collectionViewLayout invalidateLayout];
        self.contentCollectionView.frame = CGRectMake(0, 0, kScreenWidth, kContentHeight+kSlideBarHeight);
    }


}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    self.panGesture.enabled = YES;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    int currentIndex = self.contentCollectionView.contentOffset.x /self.contentCollectionView.bounds.size.width;
    self.currentTabIndex = currentIndex;
    [self.slideBar selectSlideBarItemAtIndex:currentIndex];

    [self filterBtnHidden:currentIndex];
    //删除倒计时
    if (self.currentTabIndex!=self.dealDashIndexTag) {
        [self deleteTimer];
    }else {
        //读取抢购时间
        [self postDealdash];
    }
    //冲刺
    [self setupShoppingSpree];
    //显示隐藏选项卡
    [self toggleSlider];
    
    //二级菜单
    if (self.secondCategory[self.currentTabIndex] && ((NSArray *)self.secondCategory[self.currentTabIndex]).count>0) {
        [self initSecondSlideBar];
    }
    
    if (self.currentTabIndex == self.dealDashIndexTag) {
        [self.contentCollectionView.collectionViewLayout invalidateLayout];
        self.contentCollectionView.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth, kContentHeight);
    }

    int homeid = 0;
    if (self.currentTabIndex < self.firstCategory.count){
        homeid = [self.firstIdCategory[self.currentTabIndex] intValue];
    }
    
    if (self.currentTabIndex !=self.dealDashIndexTag) {
        if (self.currentTabIndex!=0) {
            [self setupFilterScrollView];
        }else{
            if (homeid>=0) {
                [self setupFilterScrollView];
            }
        }
    }
    
    if (self.currentTabIndex == 0 && homeid < 0) {
        self.filterView.hidden = YES;
        self.hasOption = NO;

        [self.view bringSubviewToFront:self.slideBar];
        [UIView animateWithDuration:0.1 animations:^{
            self.slideBar.frame = CGRectMake(0, -kSlideBarHeight, kScreenWidth, kSlideBarHeight);
        }];
       
    }else{
        [self.view bringSubviewToFront:self.slideBar];
        [UIView animateWithDuration:0.1 animations:^{
            self.slideBar.frame = CGRectMake(0, 0, kScreenWidth, kSlideBarHeight);
        }];
    }
    

}

//销毁timer
- (void)deleteTimer {
    if (self.timerArr.count>0) {
        for (UIView *view in self.timerArr) {
            if ([view isKindOfClass:[DealDashView class]]){
                DealDashView *dealView = (DealDashView *) view;
                [dealView invalidateTimer];
                [dealView removeFromSuperview];
            }
            if ([view isKindOfClass:[ShoppingSpreeView class]]){
                ShoppingSpreeView *shoppingView = (ShoppingSpreeView *) view;
                [shoppingView invalidateTimer];
                [shoppingView removeFromSuperview];
            }

        }
    }
    [self.timerArr removeAllObjects];
}

 //无筛选项时隐藏筛选按键
- (void) filterBtnHidden:(NSInteger)section{
    if (section < self.categoryfilter.count){
        NSArray *arry = self.categoryfilter[section];
        if (0 < arry.count){
            self.filterBtn.hidden = NO;
        }else {
            self.filterBtn.hidden = YES;
        }
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)leftItemAction {
    [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];
    [self hideSlideBar];

}


- (void)filterAction:(UIButton *)sender {
    if (self.mm_drawerController.openSide == MMDrawerSideRight) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }else{
        self.isOpenFilter = !self.isOpenFilter;
        if (self.isOpenFilter) {
            [self openFilter];
            [self.filterBtn setImage:[UIImage imageNamed:@"confirm"] forState:UIControlStateNormal];
            [self.searchBtn setImage:[UIImage imageNamed:@"cancel"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.slideBar];
            [UIView animateWithDuration:0.1 animations:^{
                self.slideBar.frame = CGRectMake(0, 0, kScreenWidth, kSlideBarHeight);
            }];
        }else{
            [self closeFilter];
            //获取设置条件值
            NSArray *options = [self.filterViewController getSelectedArray];
            self.optionArr[self.currentTabIndex] = [NSMutableArray arrayWithArray:options];
            
            [self.filterBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
            [self.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
            
            //商品显示界面传值
            [self setProductId:self.currentTabIndex];
        }
    }
    
    [self hideSlideBar];

}
- (void)searchAction:(UIButton *)sender {
    if (self.mm_drawerController.openSide == MMDrawerSideRight) {
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }else{
        if (self.isOpenFilter) {
            self.isOpenFilter = !self.isOpenFilter;
            [self closeFilter];
            [self.filterBtn setImage:[UIImage imageNamed:@"filter"] forState:UIControlStateNormal];
            [self.searchBtn setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
        }else{
            UINavigationController *nav = (UINavigationController *)self.mm_drawerController.leftDrawerViewController;
            [nav popToRootViewControllerAnimated:NO];
            LeftViewController *leftVC = (LeftViewController *)nav.topViewController;
            [leftVC startSearch];
            [self.mm_drawerController toggleDrawerSide:MMDrawerSideLeft animated:YES completion:nil];

        }
    }

    [self hideSlideBar];
}

- (void)openFilter {
    self.filterView.hidden = YES;
    self.slideBar.userInteractionEnabled = NO;
    self.panGesture.enabled = NO;
    
    if (self.currentTabIndex < [self.categoryfilter count] && self.currentTabIndex < self.optionArr.count){
        [self.filterViewController setFilterArray:self.categoryfilter[self.currentTabIndex] oldFilterArray:self.optionArr[self.currentTabIndex]];
    }
    
    self.filterViewController.view.frame = CGRectMake(0, -1000, kScreenWidth, kContentHeight);
    [UIView animateWithDuration:0.5f animations:^{
        self.filterViewController.view.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth, kContentHeight);
    }];
}

- (void)closeFilter {
    self.slideBar.userInteractionEnabled = YES;
    self.panGesture.enabled = YES;
    
    [UIView animateWithDuration:0.5f animations:^{
        self.filterViewController.view.frame = CGRectMake(0, -1000, kScreenWidth, kContentHeight);
    } completion:^(BOOL finished) {
        [self setupFilterScrollView];
    }];
}

//显示筛选条件
- (void)setupFilterScrollView {
   
    NSArray *array = self.optionArr[self.currentTabIndex];

    [self.optionSArr removeAllObjects];
    
    for (int i=0; i<array.count; i++){
        FiltersModel *filterData= [FiltersModel mj_objectWithKeyValues:self.categoryfilter[(int)self.currentTabIndex][i]];
        NSArray *arraytmp = array[i];
        for (int j=0; j<arraytmp.count; j++){
            
            int num = [arraytmp[j] intValue];
            [self.optionSArr addObject:filterData.condition[num]];
        }
    }
    if (self.optionSArr.count!=0) {
        self.hasOption = YES;
        [self changeViewControllerFrame:YES];
        [self initScrollViewWithContent:self.optionSArr];
        self.filterView.hidden = NO;
    }else{
        self.hasOption = NO;
        [self changeViewControllerFrame:NO];
        self.filterView.hidden = YES;
    }
}

- (void)changeViewControllerFrame:(BOOL)open {
    if (open) {
        [self.contentCollectionView.collectionViewLayout invalidateLayout];
        CGRect rect = self.contentCollectionView.frame;
        rect.origin.y = 2*kSlideBarHeight;
        rect.size.height = kContentHeight-kSlideBarHeight;
        [UIView animateWithDuration:0.1f animations:^{
            self.contentCollectionView.frame = rect;
        }];
    }else{
        [self.contentCollectionView.collectionViewLayout invalidateLayout];
        CGRect rect = self.contentCollectionView.frame;
        rect.origin.y = kSlideBarHeight;
        rect.size.height = kContentHeight;
        [UIView animateWithDuration:0.1f animations:^{
            self.contentCollectionView.frame = rect;
        }];
    }

}
//主界面筛选条件删除
- (void)deleteAction:(UIButton *)sender {
    
    NSArray *array = self.optionArr[self.currentTabIndex];
    
    for (int i=0; i<array.count; i++){
        FiltersModel *filterData= [FiltersModel mj_objectWithKeyValues:self.categoryfilter[(int)self.currentTabIndex][i]];
        NSArray *arraytmp = array[i];
        for (int j=0; j<arraytmp.count; j++){
            int num = [arraytmp[j] intValue];
            if ([sender.titleLabel.text isEqualToString:filterData.condition[num]]){
                [self.optionArr[self.currentTabIndex][i] removeObject:arraytmp[j]];
            }
        }
        
    }

    [self.optionSArr removeObject:sender.titleLabel.text];
    [self.btnSet removeAllObjects];
    [self initScrollViewWithContent:self.optionSArr];
    
    [self.view sendSubviewToBack:self.filterView];
    CGRect rect = self.filterView.frame;
    rect.origin.y = 0;
    self.filterView.frame = rect;
    rect.origin.y = kSlideBarHeight;

    [UIView animateWithDuration:0.3f animations:^{
        self.filterView.frame = rect;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.filterView];
    }];
    
    if (!self.hasOption) {
        [self changeViewControllerFrame:NO];
    }
    
    //商品显示界面传值
    [self setProductId:self.currentTabIndex];
}

- (void)deleteAllAction {
    NSArray *tempArr = self.optionArr[self.currentTabIndex];
    for (int i=0; i<tempArr.count; i++) {
        [self.optionArr[self.currentTabIndex][i] removeAllObjects];
    }
    [self.optionSArr removeAllObjects];
    [self.btnSet removeAllObjects];
    [self initScrollViewWithContent:self.optionSArr];

    CGRect rect = self.filterView.frame;
    rect.origin.y = 0;
    [self.view sendSubviewToBack:self.filterView];
    [UIView animateWithDuration:0.3f animations:^{
        self.filterView.frame = rect;
    } completion:^(BOOL finished) {
        [self.view bringSubviewToFront:self.filterView];
        CGRect rect = self.filterView.frame;
        rect.origin.y = kSlideBarHeight;
        self.filterView.frame = rect;
    }];
    
    [self changeViewControllerFrame:NO];
    
    [self setProductId:self.currentTabIndex];

}
//显示开始冲刺
- (void)setupShoppingSpree {
    if (self.currentTabIndex == self.dealDashIndexTag) {
        if (self.isSpree) {
            [self changeViewControllerFrame:YES];
            self.spreeView.hidden = NO;
        }
    }else{
        if (!self.hasOption) {
            if (self.currentTabIndex!=0) {
                [self changeViewControllerFrame:NO];
            }
        }
        self.spreeView.hidden = YES;
    }
}

#pragma mark - notification
//产品详细通知
- (void)pushToDetailViewController:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSNumber *prodId = [dic objectForKey:@"index"];
    NSNumber *isDealDash = [dic objectForKey:@"dealdash"];
    NSString *title = [dic objectForKey:@"title"];
    ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
    productDetailVC.productId = prodId;
    productDetailVC.producttitle = title;
    if ([isDealDash integerValue]==1) {
        productDetailVC.lastTime = self.spreeView.countdown;
    }
    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    nav.interactivePopGestureRecognizer.enabled = NO;
    [nav pushViewController:productDetailVC animated:YES];
}
//home界面通知
- (void)pushToHomeDetailViewController:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSString *linktype = [dic objectForKey:@"linktype"];
    NSString *title = [dic objectForKey:@"title"];

    if ([linktype isEqualToString:@"product"]){
      
        NSNumber *linkvalue = [dic objectForKey:@"linkvalue"];
        
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
        productDetailVC.productId = linkvalue;
        productDetailVC.producttitle = title;
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        nav.interactivePopGestureRecognizer.enabled = NO;
        [nav pushViewController:productDetailVC animated:YES];
        
    }else if ([linktype isEqualToString:@"url"]){
       
        NSString *linkvalue = [dic objectForKey:@"linkvalue"];

        AdWebViewController *adWebVC = [[AdWebViewController alloc] init];
        adWebVC.urlPath = linkvalue;
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:adWebVC animated:YES];
        
    }else if ([linktype isEqualToString:@"search"]){
       
        NSString *linkvalue = [dic objectForKey:@"linkvalue"];

        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchName = title;
        searchVC.searchText = linkvalue;
        searchVC.searchType = @"home";
        searchVC.isHome = YES;
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:searchVC animated:YES];

    }else if ([linktype isEqualToString:@"searchcategory"]){
       
        NSString *linkvalue = [dic objectForKey:@"linkvalue"];
        
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchName = title;
        searchVC.searchText = linkvalue;
        searchVC.searchType = @"specialcode";
        searchVC.isHome = YES;
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:searchVC animated:YES];
        
    }
    
}

- (void)moveToCategoryViewController:(NSNotification *)notification {
    NSDictionary *dic = notification.userInfo;
    NSInteger idx = [dic[@"categoryId"] integerValue];
    
    for (int i=0; i<self.firstIdCategory.count; i++) {
        if (idx==[self.firstIdCategory[i] integerValue]) {
            self.currentTabIndex = i;
            [self.slideBar selectSlideBarItemAtIndex:i];
            [self.contentCollectionView setContentOffset:CGPointMake(i *self.contentCollectionView.bounds.size.width, 0) animated:YES];

            if (self.currentTabIndex !=self.dealDashIndexTag) {
                [self setupFilterScrollView];
                [self filterBtnHidden:self.currentTabIndex];
                //删除倒计时
                [self deleteTimer];
                //冲刺
                [self setupShoppingSpree];
                //显示隐藏选项卡
                [self toggleSlider];
            }
            
            //二级菜单
            if (self.secondCategory[self.currentTabIndex] && ((NSArray *)self.secondCategory[self.currentTabIndex]).count>0) {
                [self initSecondSlideBar];
            }
            [self setProductId:i];

            break;
        }
    }

    
}

//计算产品id
- (NSString *)getProductId{
    NSString *productId;
    if (self.secondIndex!=-1) {
        if (self.thirdIndex!=-1) {
            productId = self.thirdIdCategory[self.currentTabIndex][self.secondIndex][self.thirdIndex];
        }else{
            productId = self.secondIdCategory[self.currentTabIndex][self.secondIndex];
        }
    }else{
        productId = self.firstIdCategory[self.currentTabIndex];
    }
    return productId;
}

//向商品显示界面设置商品类ID和筛选条件
- (void) setProductId:(NSInteger)section{

    self.currentTabIndex = section;
    NSNumber *productId = [NSNumber numberWithInteger:[[self getProductId] integerValue]];
    //筛选条件
    if (section < self.optionArr.count && section < self.categoryfilter.count){
        NSArray *array = self.optionArr[section];
        NSArray *tmpAr = self.categoryfilter[section];
        
        [self.selectFilter removeAllObjects];
        
        for (int i=0; i<array.count; i++){
            FiltersModel *filter = [[FiltersModel alloc] init];
            NSMutableArray *tmpArr = [NSMutableArray array];
            if (i < tmpAr.count){
                FiltersModel *filterData= [FiltersModel mj_objectWithKeyValues:self.categoryfilter[section][i]];
                NSArray *arraytmp = array[i];
                for (int j=0; j<arraytmp.count; j++){
                    
                    int num = [arraytmp[j] intValue];
                    
                    if (num < filterData.condition.count){
                        [tmpArr addObject:filterData.condition[num]];
                    }
                }
                if (arraytmp.count > 0){
                    filter.name = filterData.name;
                    filter.condition = tmpArr;
                    [self.selectFilter addObject:filter];
                }
            }
        }
        // 将模型数组转为字典数组
        NSArray *dictArray = [FiltersModel mj_keyValuesArrayWithObjectArray:self.selectFilter];
        //    NSLog(@"%@",dictArray);
        [self.collectionViewCell.productsViewController setProductId:productId setFilter:dictArray setType:ProductTypeCategory];
    }
}

#pragma mark - contentCollectionView的代理方法和数据源方法

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{

    return self.firstCategory.count;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return self.contentCollectionView.bounds.size;
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0,0,0,0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSInteger row = indexPath.row;

    int homeid = [self.firstIdCategory[row] intValue];
    if (row==0 && homeid < 0) {
        
        [self.view bringSubviewToFront:self.slideBar];
        [UIView animateWithDuration:0.1 animations:^{
            self.slideBar.frame = CGRectMake(0, -kSlideBarHeight, kScreenWidth, kSlideBarHeight);
        }];
        [self.contentCollectionView.collectionViewLayout invalidateLayout];
        self.contentCollectionView.frame = CGRectMake(0, 0, kScreenWidth, kContentHeight+kSlideBarHeight);
        
        YLWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,(int)indexPath.row] forIndexPath:indexPath];
        
        [cell setupCollectionViewType:CollectionViewCellTypeHome];
        return cell;
        
    }else{
        [self.view bringSubviewToFront:self.slideBar];
        [UIView animateWithDuration:0.1 animations:^{
            self.slideBar.frame = CGRectMake(0, 0, kScreenWidth, kSlideBarHeight);
            if(self.hasOption){
                self.filterView.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth, kSlideBarHeight);
            }
        }];
        
        YLWCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,(int)indexPath.row] forIndexPath:indexPath];
        [cell setupCollectionViewType:CollectionViewCellTypeCategory];
        self.collectionViewCell = cell;
        [cell.productsViewController.collectionView setContentOffset:CGPointMake(0, 0)];
        
        if (self.isStartDash){
            if ([self.firstCategory[row] hasSuffix:@".png"] == YES){
                if (self.isDealDash) {
                    if (!self.isSpree) {
                        //
                        [self.spreeView removeFromSuperview];
                        self.spreeView = nil;
                        
                        self.startDealView = [[DealDashView alloc] initWithType:DealDashTypeStart countdown:3];//3 2 1 倒计时间

                        [cell addSubview:self.startDealView];
                        [self.startDealView mas_makeConstraints:^(MASConstraintMaker *make) {
                            make.edges.mas_equalTo(cell);
                        }];
                        [self.timerArr addObject:self.startDealView];
                        
                        if (self.isSelectYes) {
                            [self.startDealView goAction];
                        }
                        
                        __weak typeof(CenterViewController *)weakSelf = self;
                        self.startDealView.startDealDashBlock = ^{
                            __strong typeof(CenterViewController *)strongSelf = weakSelf;
                            strongSelf.isSelectYes = NO;

                            strongSelf.isSpree = YES;
                            strongSelf.panGesture.enabled = YES;
                            
                            [strongSelf postStartDash];
                            
                            [strongSelf.startDealView removeFromSuperview];
                            strongSelf.startDealView = nil;
                            //商品显示界面传值,抢购的产品列表在抢购开始后重新读取
                            [strongSelf setProductId:strongSelf.currentTabIndex];
                            
                            
                        };
                    }else{
                        
                        [self changeViewControllerFrame:YES];
                        [self.spreeView removeFromSuperview];
                        [self.endDealView removeFromSuperview];
                        [self.startDealView removeFromSuperview];
                        self.spreeView = nil;
                        self.endDealView = nil;
                        self.startDealView = nil;
                        
                        //由于刷新时会多次建立DealDashView的图层，没移除时会遮住产品界面
                        for (int i=0; i<self.timerArr.count; i++){
                            UIView *tmpView = self.timerArr[i];
                            
                                [tmpView removeFromSuperview];
                           
                            
                        }
                        [self deleteTimer];
                        
                        if (self.hGoing > 0){
                            self.spreeView = [[ShoppingSpreeView alloc] initWithCountdown:self.hGoing];//十分钟抢购倒计时
                        }else {
                            self.spreeView = [[ShoppingSpreeView alloc] initWithCountdown:600];//十分钟抢购倒计时
                        }
                        
                        self.spreeView.frame = CGRectMake(0, kSlideBarHeight, kScreenWidth, kSlideBarHeight);
                        [self.view addSubview:self.spreeView];
                        [self.view bringSubviewToFront:self.spreeView];
                        
                        [self.timerArr addObject:self.spreeView];
                        
                        __weak typeof(CenterViewController *)weakSelf = self;
                        self.spreeView.spreeEndBlock = ^{
                            __strong typeof(CenterViewController *)strongSelf = weakSelf;
                            strongSelf.panGesture.enabled = NO;
                            strongSelf.isDealDash = NO;
                            
                            strongSelf.isSpree = NO;
                            
                            [strongSelf changeViewControllerFrame:NO];
                            [strongSelf.spreeView removeFromSuperview];
                            strongSelf.spreeView = nil;
                            [strongSelf postDealdash];
                            //                        [collectionView reloadData];
                            
                        };
                        
                        //                    NSLog(@"self.timerArr is %@", self.timerArr);
                    }
                }else{
                    [self.spreeView removeFromSuperview];
                    self.spreeView = nil;
                    
                    self.endDealView = [[DealDashView alloc] initWithType:DealDashTypeEnd countdown:self.hLeft];//进入抢购还剩时间倒计时

                    [cell addSubview:self.endDealView];
                    [self.endDealView mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.edges.mas_equalTo(cell);
                    }];
                    [self.timerArr addObject:self.endDealView];
                    
                    __weak typeof(CenterViewController *)weakSelf = self;
                    self.endDealView.endDealDashBlock = ^{
                        __strong typeof(CenterViewController *)strongSelf = weakSelf;
                        strongSelf.isDealDash = YES;
                        
                        [strongSelf.endDealView removeFromSuperview];
                        strongSelf.endDealView = nil;
                        [collectionView reloadData];
                    };
                }

            }
        }
        
        //        NSLog(@"self.timerArr is %@", self.timerArr);
        
        //商品显示界面传值
        [self setProductId:row];
        
        if ([self.firstCategory[row] hasSuffix:@".png"]){
            cell.isDealDashPage = YES;
        }else{
            cell.isDealDashPage = NO;
        }
        return cell;
    }
    
}

//显示隐藏导航栏
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIScreenEdgePanGestureRecognizer class]]) {
        return NO;
    }
    return YES;
}

//处理滑动隐藏菜单
- (void)handlePan:(UIPanGestureRecognizer *)gesture {
    if (self.firstCategory.count!=0) {
        CGPoint translation = [gesture translationInView:self.view];
        float delta = self.lastContentOffset - translation.y;
        self.lastContentOffset = translation.y;
        //    NSLog(@"%f",delta);
        
        if (!self.hasOption) {
            CGRect r1 = self.slideBar.frame;
            r1.origin.y = r1.origin.y-delta;
            
            if (r1.origin.y>0) {
                r1.origin.y = 0;
            }else if(r1.origin.y<-kSlideBarHeight){
                r1.origin.y = -kSlideBarHeight;
            }
            self.slideBar.frame = r1;
            
            if (self.currentTabIndex == self.dealDashIndexTag) {
                if (self.isDealDash&&self.isSpree) {
                    CGRect r = self.spreeView.frame;
                    r.origin.y -= delta;
                    if (r.origin.y>kSlideBarHeight) {
                        r.origin.y = kSlideBarHeight;
                    }else if(r.origin.y<0){
                        r.origin.y = 0;
                    }
                    self.spreeView.frame = r;
                    
                    [self.contentCollectionView.collectionViewLayout invalidateLayout];
                    CGRect r2 = self.contentCollectionView.frame;
                    r2.origin.y = r2.origin.y-delta;
                    r2.size.height = kScreenHeight-64-r2.origin.y;
                    
                    if (r2.origin.y>2*kSlideBarHeight) {
                        r2.origin.y = 2*kSlideBarHeight;
                        r2.size.height = kContentHeight-kSlideBarHeight;
                    }else if(r2.origin.y<kSlideBarHeight){
                        r2.origin.y = kSlideBarHeight;
                        r2.size.height = kContentHeight;
                    }
                    self.contentCollectionView.frame = r2;
                }
            }else{
                [self.contentCollectionView.collectionViewLayout invalidateLayout];
                CGRect r2 = self.contentCollectionView.frame;
                r2.origin.y = r2.origin.y-delta;
                r2.size.height = kScreenHeight-64-r2.origin.y;
                
                if (r2.origin.y>kSlideBarHeight) {
                    r2.origin.y = kSlideBarHeight;
                    r2.size.height = kContentHeight;
                }else if(r2.origin.y<0){
                    r2.origin.y = 0;
                    r2.size.height = kContentHeight+kSlideBarHeight;
                }
                self.contentCollectionView.frame = r2;
            }
            
            
        }else{
            CGRect r1 = self.slideBar.frame;
            r1.origin.y = r1.origin.y-delta;
            
            if (r1.origin.y>0) {
                r1.origin.y = 0;
            }else if(r1.origin.y<-2*kSlideBarHeight){
                r1.origin.y = -2*kSlideBarHeight;
            }
            self.slideBar.frame = r1;
            
            CGRect r2 = self.filterView.frame;
            r2.origin.y = r2.origin.y-delta;
            
            if (r2.origin.y>kSlideBarHeight) {
                r2.origin.y = kSlideBarHeight ;
            }else if(r2.origin.y<-kSlideBarHeight){
                r2.origin.y = -kSlideBarHeight;
            }
            self.filterView.frame = r2;
            
            [self.contentCollectionView.collectionViewLayout invalidateLayout];
            CGRect r3 = self.contentCollectionView.frame;
            r3.origin.y = r3.origin.y-delta;
            r3.size.height = kScreenHeight-64-r3.origin.y;
            
            if (r3.origin.y>2*kSlideBarHeight) {
                r3.origin.y = 2*kSlideBarHeight;
                r3.size.height = kContentHeight-kSlideBarHeight;
            }else if(r3.origin.y<0){
                r3.origin.y = 0;
                r3.size.height = kContentHeight+kSlideBarHeight;
            }
            self.contentCollectionView.frame = r3;
        }
        
        if (gesture.state == UIGestureRecognizerStateEnded || gesture.state == UIGestureRecognizerStateCancelled) {
            self.lastContentOffset = 0;
            
            if (!self.hasOption) {
                if (self.currentTabIndex == self.dealDashIndexTag) {
                    CGRect r3 = self.slideBar.frame;
                    CGRect r4 = self.spreeView.frame;
                    CGRect r5 = self.contentCollectionView.frame;
                    if (r5.origin.y>kSlideBarHeight) {
                        r3.origin.y = 0;
                        r4.origin.y = kSlideBarHeight;
                    }else{
                        if (delta>0) {
                            r3.origin.y = 0;
                            r4.origin.y = kSlideBarHeight;
                        }else{
                            r3.origin.y = -kSlideBarHeight;
                            r4.origin.y = 0;
                        }
                    }
                    [UIView animateWithDuration:0.1 animations:^{
                        self.slideBar.frame = r3;
                        self.spreeView.frame = r4;
                    }];
                }else{
                    CGRect r3 = self.slideBar.frame;
                    CGRect r4 = self.contentCollectionView.frame;
                    if (r4.origin.y>0) {
                        r3.origin.y = 0;
                    }else{
                        if (delta>0) {
                            r3.origin.y = 0;
                        }else{
                            r3.origin.y = -kSlideBarHeight;
                        }
                    }
                    [UIView animateWithDuration:0.1 animations:^{
                        self.slideBar.frame = r3;
                    }];
                }
            }else{
                CGRect r4 = self.slideBar.frame;
                CGRect r5 = self.filterView.frame;
                CGRect r6 = self.contentCollectionView.frame;
                if (r6.origin.y>0) {
                    r4.origin.y = 0;
                    r5.origin.y = kSlideBarHeight;
                }else{
                    if (delta>0) {
                        r4.origin.y = 0;
                        r5.origin.y = kSlideBarHeight;
                    }else{
                        r4.origin.y = -2*kSlideBarHeight;
                        r5.origin.y = -kSlideBarHeight;
                    }
                }
                [UIView animateWithDuration:0.1 animations:^{
                    self.slideBar.frame = r4;
                    self.filterView.frame = r5;
                }];
            }
        }
        
        //隐藏二三级目录
        [self.secondSlideBar removeFromSuperview];
        [self.thirdSlideBar removeFromSuperview];
        
    }
    
}

- (void)toggleSlider {
    if (self.currentTabIndex==self.dealDashIndexTag) {
        if (self.isDealDash&&self.isSpree) {
            self.panGesture.enabled = YES;
        }else{
            self.panGesture.enabled = NO;
        }
    }else{
        self.panGesture.enabled = YES;
    }
}

#pragma mark - notification
- (void)pushToOrderHistoryViewController:(NSNotification *)notification {
//    NSLog(@"pushToOrderHistoryViewController");
    OrderHistoryViewController *orderHistoryVC = [[OrderHistoryViewController alloc] init];
    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
    [nav pushViewController:orderHistoryVC animated:NO];
    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
}

#pragma mark --postCategories
//获取显示商品类别
- (void)postCategories{

//        NSDictionary *dict = @{
//                               @"status" : @1,
//                               @"message" : @"testst",
//                               @"data" : @[
//                                       @{
//                                           @"category_id" : @96,
//                                           @"name" : @"LATEST",
//                                           @"subcategory" : @[
//                                                    @{
//                                                        @"category_id" : @6,
//                                                        @"name" : @"NEW ARRIVALS",
//                                                        @"subcategory" : @[
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"ARRIVALS",
//                                                                    
//                                                                    },
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"BACKPACKS",
//                                                                    
//                                                                    }
//                                                                ],
//                                                        },
//                                                    @{
//                                                        @"category_id" : @6,
//                                                        @"name" : @"NEW ARRIVALS",
//                                                        @"subcategory" : @[
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"ARRIVALS",
//                                                                    
//                                                                    },
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"BACKPACKS",
//                                                                    
//                                                                    }
//                                                                ],
//                                                        }
//                                                    
//                                                    ],
//                                           @"filters" : @[
//                                                   @{
//                                                       @"name" : @"size",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206235119558.jpg",
//                                                       @"condition" : @[@"XXS", @"XS", @"S", @"M"]
//    
//                                                       },
//                                                   @{
//                                                          @"name" : @"color",
//                                                          @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206234807148.jpg",
//                                                          @"condition" : @[@"BLACK", @"BLUE", @"GOLD", @"GRAY"]
//    
//                                                        },
//                                                    @{
//                                                          @"name" : @"colorddddd",
//                                                          @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206234807148.jpg",
//                                                          @"condition" : @[@"BLAdddCK", @"BLUEjjj", @"GOLshhssD", @"GRAYddd"]
//    
//                                                    }
//                                                ]
//    
//    
//    
//                                       },
//                                       @{
//                                            @"category_id" : @97,
//                                            @"name" : @"REWDDD",
//                                            @"subcategory" : @[
//                                                    @{
//                                                        @"category_id" : @6,
//                                                        @"name" : @"NEW ARRIVALS",
//                                                        @"subcategory" : @[ ],
//                                                        },
//                                                    @{
//                                                        @"category_id" : @6,
//                                                        @"name" : @"NEW ARRIVALS",
//                                                        @"subcategory" : @[
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"ARRIVALS",
//                                                                    
//                                                                    },
//                                                                @{
//                                                                    @"category_id" : @26,
//                                                                    @"name" : @"BACKPACKS",
//                                                                    
//                                                                    }
//                                                                ],
//                                                        }
//                                                    
//                                                    ],
//
//                                            @"filters" : @[]
//    
//                                        },
//                                       @{
//                                           @"category_id" : @98,
//                                           @"name" : @"IEWED",
//                                           @"subcategory" : @[],
//                                           @"filters" : @[
//                                                   @{
//                                                       @"name" : @"size",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206235119558.jpg",
//                                                       @"condition" : @[@"XXS", @"XS", @"S", @"M"]
//                                                       
//                                                       },
//                                                   @{
//                                                       @"name" : @"color",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206234807148.jpg",
//                                                       @"condition" : @[@"BLACK", @"BLUE", @"GOLD", @"GRAY"]
//                                                       
//                                                       },
//                                                   @{
//                                                       @"name" : @"colorddddd",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206234807148.jpg",
//                                                       @"condition" : @[@"BLAdddCK", @"BLUEjjj", @"GOLshhssD", @"GRAYddd"]
//                                                       
//                                                       }
//                                                   ]
//
//    
//                                           },
//                                       @{
//                                           @"category_id" : @99,
//                                           @"name" : @"shop.png",
//                                           @"subcategory" : @[],
//                                           @"filters" : @[
//                                                   @{
//                                                       @"name" : @"size",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206235119558.jpg",
//                                                       @"condition" : @[@"XXS", @"XS", @"S", @"M"]
//    
//                                                       },
//                                                   @{
//                                                       @"name" : @"size",
//                                                       @"image" : @"http://img.sj33.cn/uploads/allimg/200912/20091206235119558.jpg",
//                                                       @"condition" : @[@"XXS", @"XS", @"S", @"M"]
//    
//                                                       }
//                                                   ]
//    
//                                           }
//                                ]
//
//                                       
//    
//                        };
//    
//    
//    
//    
//    
//    
//    
//    
//        NSLog(@"dict is%@", dict);
//    
//        NSArray *sDic = [dict objectForKey:@"data"];
//    
//        [self.firstIdCategory removeAllObjects];
//        [self.firstCategory removeAllObjects];
//        [self.categoryfilter removeAllObjects];
//    
//        if (![sDic isKindOfClass:[NSNull class]]){
//            for (int i = 0; i < sDic.count; i++) {
//    
//                CenterViewModel *categoryData= [CenterViewModel mj_objectWithKeyValues:sDic[i]];
//                [self.firstIdCategory addObject:categoryData.category_id];
//                [self.firstCategory addObject:categoryData.name];
//                [self.categoryfilter addObject:categoryData.filters];
//            
//                if ([categoryData.name hasSuffix:@".png"] == YES){
//                    
//                    self.dealDashIndexTag = i;
//                    
//                }else {
//                    self.dealDashIndexTag = 1000;
//                }
//
//            }
//
//            [self initSlideBar];
//            [self initEdgeView];
//            [self.view addSubview:self.contentCollectionView];
//        }
//
////        NSLog(@"self.firstIdCategory is%@", self.firstIdCategory);
////        NSLog(@"self.firstCategory is%@", self.firstCategory);
////        NSLog(@"self.categoryfilter is%@", self.categoryfilter);
//
    
    
    
    [MBPromptView showLoadingView:self.view];

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id =[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];

    if (0==customer_id.length || 0==token.length){
        [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
        [parameters setObject:@"" forKey:@"token"];
    }else{
        [parameters setObject:customer_id forKey:@"customer_id"];
        
        [parameters setObject:token forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    
    [parameters setObject:@"categoriesfilter" forKey:@"req"];
    
    
//    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
//    NSString *Pstring = [parameters mj_JSONString];
//    [postParameter setObject:Pstring forKey:@"handler"];
    
//    NSLog(@"parameters is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
        
        [MBPromptView hideLoadingView];
        
//       NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            
            NSArray *sDic = [responseBody objectForKey:@"data"];
            
            [self.firstIdAllCategory removeAllObjects];
            [self.firstAllCategory removeAllObjects];
            [self.categoryfilter removeAllObjects];
            
            if (![sDic isKindOfClass:[NSNull class]]){
                
                for (int i = 0; i < sDic.count; i++) {
                    CenterViewModel *categoryData= [CenterViewModel mj_objectWithKeyValues:sDic[i]];
                    if ([categoryData.name hasSuffix:@".png"] == YES){
                        //未登录时不显示限时抢购
                        if (0==customer_id.length || 0==token.length){
                            continue;
                        }
                        self.dealDashIndexTag = i;
                    }
                    [self.firstIdAllCategory addObject:categoryData.category_id];
                    [self.firstAllCategory addObject:categoryData.name];
                    [self.categoryfilter addObject:categoryData.filters];

                    NSArray *subArr = categoryData.subcategory;
                    if (subArr.count!=0) {
                        NSMutableArray *secondArr = [NSMutableArray array];
                        NSMutableArray *secondIdArr = [NSMutableArray array];
                        NSMutableArray *secondThirdArr = [NSMutableArray array];
                        NSMutableArray *secondThirdIdArr = [NSMutableArray array];
                        
                        for (int i=0; i<subArr.count; i++) {
                            SubcategoryModel *secondModel = [SubcategoryModel mj_objectWithKeyValues:subArr[i]];
                            [secondArr addObject:secondModel.name];
                            [secondIdArr addObject:secondModel.category_id];
                            
                            NSArray *ssubArr = secondModel.subcategory;
                            if (ssubArr.count!=0) {
                                NSMutableArray *thirdArr = [NSMutableArray array];
                                NSMutableArray *thirdIdArr = [NSMutableArray array];
                                for (int j=0; j<ssubArr.count; j++) {
                                    SubcategoryModel *thirdModel = [SubcategoryModel mj_objectWithKeyValues:ssubArr[j]];
                                    [thirdArr addObject:thirdModel.name];
                                    [thirdIdArr addObject:thirdModel.category_id];
                                }
                                [secondThirdArr addObject:thirdArr];
                                [secondThirdIdArr addObject:thirdIdArr];
                            }else{
                                [secondThirdArr addObject:@[]];
                                [secondThirdIdArr addObject:@[]];
                            }
                        }

                        [self.secondAllCategory addObject:secondArr];
                        [self.secondIdAllCategory addObject:secondIdArr];
                        [self.thirdAllCategory addObject:secondThirdArr];
                        [self.thirdIdAllCategory addObject:secondThirdIdArr];
                    }else{
                        [self.secondAllCategory addObject:@[]];
                        [self.secondIdAllCategory addObject:@[]];
                        [self.thirdAllCategory addObject:@[]];
                        [self.thirdIdAllCategory addObject:@[]];
                    }
                }
                
                if (self.dealDashIndexTag!=kDealDashDeault) {
                    if (self.isDealDash&&!self.isSpree) {//可以点击go
                        self.dashTime = 0;
                        if (self.dashTimer == nil){
                            self.dashTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(dashTimerAction) userInfo:nil repeats:YES];
                            [[NSRunLoop mainRunLoop] addTimer:self.dashTimer forMode:NSRunLoopCommonModes];
                        }
                        [self toggleDealDash:YES];

                    }else if(self.isDealDash&&self.isSpree){//10分钟抢购
                        [self toggleDealDash:NO];
                    }else if(!self.isDealDash&&!self.isSpree){//24小时倒计时
                        [self toggleDealDash:YES];
                    }
                }else{
                    self.firstCategory = [self.firstAllCategory mutableCopy];
                    self.firstIdCategory = [self.firstIdAllCategory mutableCopy];
                    self.secondCategory = [self.secondAllCategory mutableCopy];
                    self.secondIdCategory = [self.secondIdAllCategory mutableCopy];
                    self.thirdCategory = [self.thirdAllCategory mutableCopy];
                    self.thirdIdCategory = [self.thirdIdAllCategory mutableCopy];
                }                
                
                for (int i = 0; i <self.firstAllCategory.count; i ++) {
                    [self.contentCollectionView registerClass:[YLWCollectionViewCell class] forCellWithReuseIdentifier:[NSString stringWithFormat:@"%@%d",contentIdentifier,i]];
                }
                [self.view addSubview:self.contentCollectionView];

                [self initSlideBar];
                [self initEdgeView];
                //第一页显示是否有筛选项
                [self filterBtnHidden:0];


            }

        }else {
            NSString *message = [responseBody objectForKey:@"message"];
            if (message != nil){
                [ZXZPromptView failWithDetail:message];
            }
        }
        
    } failureBlock:^(NSString *error){
        [MBPromptView hideLoadingView];
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
    }];
    
}



#pragma mark --postDealdash
//获取抢购时间
- (void)postDealdash{
    
//    NSDictionary *dict = @{
//                           @"status" : @1,
//                           @"message" : @"testst",
//                           @"data" : @{
//                                   
//                                   @"hourly_going" : @0,
//                                   @"hourly_left" : @40
//                                   }
//                           
//                           };
//      NSLog(@"dict is%@", dict);
//    
//    NSDictionary *sDic = [dict objectForKey:@"data"];
//    
//    
//    if (![sDic isKindOfClass:[NSNull class]]){
//
//        self.hGoing = [[sDic objectForKey:@"hourly_going"] integerValue];//10分钟购物倒计时
//        self.hLeft = [[sDic objectForKey:@"hourly_left"] integerValue];//剩余多长时间可以进入倒计时购物
//
//        if (self.hGoing > 0){
//            self.isSpree = YES;
//            self.isDealDash = YES;
//        }else if (self.hLeft > 0){
//            self.isSpree = NO;
//            self.isDealDash = NO;
//        }else{
//            self.isSpree = NO;
//            self.isDealDash = YES;
//        }
//        
//        [self.contentCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dealDashIndexTag inSection:0]]];
//        
//    }
    
    
    
        NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
        //用户id
        NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
        NSString *customer_id=[defaults objectForKey:@"Userid"];
        NSString *token=[defaults objectForKey:@"Token"];
    
        if (0==customer_id.length || 0==token.length){
            [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
            [parameters setObject:@"" forKey:@"token"];
        }else{
            [parameters setObject:customer_id forKey:@"customer_id"];
            [parameters setObject:token forKey:@"token"];
        }
    
        [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    
        [parameters setObject:@"dealdash" forKey:@"req"];
    
    
    
    //    NSLog(@"parameters is %@", parameters);
        [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
    
//            NSLog(@"获取数据成功 is %@", responseBody);
    
            NSNumber *status = [responseBody objectForKey:@"status"];
            NSNumber *s= [NSNumber numberWithInt:1];
            if ([status isEqualToNumber:s]){
    
                NSDictionary *sDic = [responseBody objectForKey:@"data"];

                if (![sDic isKindOfClass:[NSNull class]]){
                    
                    self.hGoing = [[sDic objectForKey:@"hourly_going"] integerValue];//10分钟购物倒计时
                    self.hLeft = [[sDic objectForKey:@"hourly_left"] integerValue];//剩余多长时间可以进入倒计时购物
                    
                    if (self.hGoing > 0){
                        self.isSpree = YES;
                        self.isDealDash = YES;
                    }else if (self.hLeft > 0){
                        self.isSpree = NO;
                        self.isDealDash = NO;
                    }else{
                        self.isSpree = NO;
                        self.isDealDash = YES;
                    }

                    if (!self.isStartDash) {
                        [self postCategories];
                    }
                    self.isStartDash = YES;
                    if (self.dealDashIndexTag!=kDealDashDeault) {
                        [self.contentCollectionView reloadData];
                    }
                    
                }
    
            }else {
                NSString *message = [responseBody objectForKey:@"message"];
                if (message != nil){
                    [ZXZPromptView failWithDetail:message];
                }
            }
            
        } failureBlock:^(NSString *error){
            
            [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
            
        }];
    
}


#pragma mark --postStartDash
//抢购开始
- (void)postStartDash{
    
//        NSDictionary *dict = @{
//                               @"status" : @1,
//                               @"message" : @"testst",
//                               @"data" : @{
//    
//                                       @"hourly_going" : @60,
//                                       @"hourly_left" : @40
//                                       }
//    
//                               };
//          NSLog(@"dict is%@", dict);
//    
//        NSDictionary *sDic = [dict objectForKey:@"data"];
//    
//    
//        if (![sDic isKindOfClass:[NSNull class]]){
//    
//            self.hGoing = [[sDic objectForKey:@"hourly_going"] integerValue];//10分钟购物倒计时
//            self.hLeft = [[sDic objectForKey:@"hourly_left"] integerValue];//剩余多长时间可以进入倒计时购物
//    
//            if (self.hGoing > 0){
//                self.isSpree = YES;
//                self.isDealDash = YES;
//            }else if (self.hLeft > 0){
//                self.isSpree = NO;
//                self.isDealDash = NO;
//            }else{
//                self.isSpree = NO;
//                self.isDealDash = YES;
//            }
//    
//            [self.contentCollectionView reloadItemsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.dealDashIndexTag inSection:0]]];
//    
//        }
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id=[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    if (0==customer_id.length || 0==token.length){
        [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
        [parameters setObject:@"" forKey:@"token"];
    }else{
        [parameters setObject:customer_id forKey:@"customer_id"];
        [parameters setObject:token forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    
    [parameters setObject:@"startdash" forKey:@"req"];
    
    
    
    //    NSLog(@"parameters is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
        
//        NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            
            NSDictionary *sDic = [responseBody objectForKey:@"data"];
            
            if (![sDic isKindOfClass:[NSNull class]]){
                
                self.hGoing = [[sDic objectForKey:@"hourly_going"] integerValue];//10分钟购物倒计时
                self.hLeft = [[sDic objectForKey:@"hourly_left"] integerValue];//剩余多长时间可以进入倒计时购物
                if (self.hGoing > 0){
                    self.isSpree = YES;
                    self.isDealDash = YES;
                }else{
                    self.isSpree = NO;
                    self.isDealDash = NO;
                }
                if (self.dealDashIndexTag!=kDealDashDeault) {
                    [self.contentCollectionView reloadData];
                }
            }
            
        }else {
            NSString *message = [responseBody objectForKey:@"message"];
            if (message != nil){
                [ZXZPromptView failWithDetail:message];
            }
        }
        
    } failureBlock:^(NSString *error){
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
    }];
    
}


#pragma mark --postSavePhone
//保存用户手机信息
- (void)postSavePhone{
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id=[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    if (0==customer_id.length || 0==token.length){
        [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
        [parameters setObject:@"" forKey:@"token"];
    }else{
        [parameters setObject:customer_id forKey:@"customer_id"];
        [parameters setObject:token forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager savePhoneInfo] forKey:@"phoneinfo"];//手机信息
    
    [parameters setObject:@"savephone" forKey:@"req"];
    
//    NSLog(@"parameters is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
        
//        NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            
        }
        
    } failureBlock:^(NSString *error){
    }];
    
}




@end
