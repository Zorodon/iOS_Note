//
//  GoosListViewController.m
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import "GoosListViewController.h"
#import "GoodsListCell.h"
#import "MJRefresh.h"
#import "CustomerSupportModel.h"
#import "ProductDetailViewController.h"

@interface GoosListViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UITableView*GoodsListTable;

@property(nonatomic, strong) NSNumber *currentPage;//页数
@property(nonatomic, strong) NSNumber *totalPage;//总页数
@property (assign, nonatomic) BOOL isMore;

@property(nonatomic,strong)NSMutableArray*productArr;
@property (strong, nonatomic) UIView *noProductView;

@end

@implementation GoosListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=ZDLocalizedString(@"ProductRecord", nil);
   
    //上个页面标题太长导致title不居中
    NSArray *viewControllerArray = [self.navigationController viewControllers];
    long previousViewControllerIndex = [viewControllerArray indexOfObject:self] - 1;
    UIViewController *previous;
    if (previousViewControllerIndex >= 0) {
        previous = [viewControllerArray objectAtIndex:previousViewControllerIndex];
        previous.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc]
                                                     initWithTitle:@" "
                                                     style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:nil];
    }
    
    [self initGoodsListTableView];
    
    [self initData];
    
    MJRefreshBackNormalFooter *footer =[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        
        int totalpage = [self.totalPage intValue];
        int page = [self.currentPage intValue];
        if (page < totalpage){
            page = page +1;
            //刷新时获取数据
            self.currentPage = [NSNumber numberWithInt:page];//从第一页开始
            [self postSupportProductList];
            self.isMore = YES;
        }else {
            
            
            [self.GoodsListTable.mj_footer endRefreshingWithNoMoreData];
        }
    }];
    self.GoodsListTable.mj_footer = footer;
    // 设置文字
    [footer setTitle:ZDLocalizedString(@"ClickDragRefresh", nil) forState:MJRefreshStateIdle];
    [footer setTitle:ZDLocalizedString(@"RLoadMore", nil) forState:MJRefreshStatePulling];
    [footer setTitle:ZDLocalizedString(@"Loading", nil) forState:MJRefreshStateRefreshing];
    [footer setTitle:ZDLocalizedString(@"NoMoreData", nil) forState:MJRefreshStateNoMoreData];
    // 设置字体
    footer.stateLabel.font = [UIFont boldSystemFontOfSize:13];
    // 设置颜色
    footer.stateLabel.textColor = bGroundColor;
    
}

- (void) initData{
 
    _productArr =  [[NSMutableArray alloc] init];
    
     self.currentPage = [NSNumber numberWithInt:1];//从第一页开始
     [self postSupportProductList];
     self.totalPage = [NSNumber numberWithInt:1];
     self.isMore = NO;
}

-(void)initGoodsListTableView{
    self.GoodsListTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _GoodsListTable.tableFooterView=[[UIView alloc]initWithFrame:CGRectZero];
    _GoodsListTable.backgroundColor=[UIColor whiteColor];
    _GoodsListTable.delegate=self;
    _GoodsListTable.dataSource=self;
    _GoodsListTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_GoodsListTable];
    [_GoodsListTable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.bottom.equalTo(self.view.mas_bottom);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [_GoodsListTable registerClass:[GoodsListCell class] forCellReuseIdentifier:@"cellID"];
}

#pragma mark tableView  delegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{

    return self.productArr.count;

}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
     productListModel *productData = [productListModel mj_objectWithKeyValues:self.productArr[section]];
    return productData.product.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 120-35;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    GoodsListCell*cell=[[GoodsListCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cellID"];
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    
    productListModel *productData = [productListModel mj_objectWithKeyValues:self.productArr[indexPath.section]];
    [cell settingLabelValue:productData.product andIndexpath:indexPath.row];
    return  cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    
    productListModel *productData = [productListModel mj_objectWithKeyValues:self.productArr[indexPath.section]];
    productModel *product = [productModel mj_objectWithKeyValues:productData.product[indexPath.row]];
    if (product.product_id != nil){
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
        productDetailVC.productId = product.product_id;
        productDetailVC.producttitle = product.title;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }

}
#pragma mark 表头时间显示
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 35;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    productListModel *productData = [productListModel mj_objectWithKeyValues:self.productArr[section]];
    
    UIView*sectionHeaderView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 35)];
    sectionHeaderView.backgroundColor=[UIColor whiteColor];
    // 时间显示
    UILabel*time_lb = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, kScreenWidth, 15)];
    time_lb.text = [MainViewManager showDateMode:productData.date_added type:@"date"];
    time_lb.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    time_lb.font=[UIFont boldSystemFontOfSize:14];
    time_lb.textAlignment=NSTextAlignmentCenter;
    [sectionHeaderView addSubview:time_lb];
    
    return sectionHeaderView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


//没有搜索项
- (UIView *)noProductView{
    if (!_noProductView) {
        self.noProductView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.GoodsListTable addSubview:self.noProductView];
        
        UIImageView *noReviewImageV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"nosearch"]];
        [self.noProductView addSubview:noReviewImageV];
        UILabel *noReviewL = [[UILabel alloc] init];
        noReviewL.font = [UIFont boldSystemFontOfSize:12];
        noReviewL.text = ZDLocalizedString(@"NPTD", nil);
        [self.noProductView addSubview:noReviewL];
        
        [noReviewImageV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.noProductView.mas_centerX);
            make.centerY.mas_equalTo(self.noProductView.mas_centerY).mas_offset(-100);
            make.width.mas_equalTo(50);
            make.height.mas_equalTo(50);
        }];
        [noReviewL mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(self.noProductView);
            make.top.mas_equalTo(noReviewImageV.mas_bottom).mas_offset(15);
        }];

    }
    return _noProductView;
}
- (void)showNoProduct {
    if (self.noProductView) {
        self.noProductView.hidden = NO;
        [self.GoodsListTable bringSubviewToFront:self.noProductView];
    }
}
- (void)hideNoProduct {
    if(self.noProductView){
        self.noProductView.hidden = YES;
        [self.GoodsListTable sendSubviewToBack:self.noProductView];
    }
}

#pragma mark --postSupportProductList
//获取咨询商品列表
- (void)postSupportProductList{
    
//    NSDictionary *dict = @{
//                           @"status" : @1,
//                           @"message" : @"testst",
//                           @"data":@[
//                                   @{
//                                       @"date_added":@1467512353,
//                                       @"product":@[
//                                           @{
//                                               @"product_id" : @678,
//                                               @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                               @"special" : @"CN¥398",
//                                               @"price" : @"CN¥1,987",
//                                               @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                               
//                                               
//                                               },
//                                           @{
//                                               @"product_id" : @679,
//                                               @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                               @"special" : @"CN¥398",
//                                               @"price" : @"CN¥1,987",
//                                               @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                               @"date_added":@1467512353,
//                                               },
//                                           
//                                           @{
//                                               @"product_id" : @680,
//                                               @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                               @"special" : @"CN¥398",
//                                               @"price" : @"CN¥1,987",
//                                               @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                               @"date_added":@1467512353,
//                                               },
//                                           @{
//                                               @"product_id" : @681,
//                                               @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                               @"special" : @"CN¥398",
//                                               @"price" : @"CN¥1,987",
//                                               @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                               @"date_added":@1467512353,
//                                               }
//
//                                        ]
//                                   },
//                                   @{
//                                       @"date_added":@1467425593,
//                                       @"product":@[
//                                               @{
//                                                   @"product_id" : @678,
//                                                   @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                                   @"special" : @"CN¥398",
//                                                   @"price" : @"CN¥1,987",
//                                                   @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                                   
//                                                   
//                                                   },
//                                               @{
//                                                   @"product_id" : @679,
//                                                   @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                                   @"special" : @"CN¥398",
//                                                   @"price" : @"CN¥1,987",
//                                                   @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                                   @"date_added":@1467512353,
//                                                   },
//                                               
//                                               @{
//                                                   @"product_id" : @680,
//                                                   @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                                   @"special" : @"CN¥398",
//                                                   @"price" : @"CN¥1,987",
//                                                   @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                                   @"date_added":@1467512353,
//                                                   },
//                                               @{
//                                                   @"product_id" : @681,
//                                                   @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
//                                                   @"special" : @"CN¥398",
//                                                   @"price" : @"CN¥1,987",
//                                                   @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
//                                                   @"date_added":@1467512353,
//                                                   }
//                                               ]
//                                       }
//                                   
//                                ]
//
//                           };
//    
//    //         NSLog(@"**************dicArry is %@", dict);
//    
//    NSNumber *status = [dict objectForKey:@"status"];
//    NSNumber *s= [NSNumber numberWithInt:1];
//    if ([status isEqualToNumber:s]){
//        NSArray *sDic = [dict objectForKey:@"data"];
//  
//       
//        if (!self.isMore){
//            [self.productArr removeAllObjects];
//        }
//        
//        for (int i=0; i<sDic.count; i++){
//            [self.productArr addObject:sDic[i]];
//        }
//        [self.GoodsListTable reloadData];
//    }
//        
//    
//
//     [self.GoodsListTable.mj_footer endRefreshing];
    
   
    
    
    [MBPromptView showLoading];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id = [defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    if (0==customer_id.length || 0==token.length){
        [parameters setObject:@"" forKey:@"customer_id"];//未登录或是游客时
        [parameters setObject:@"" forKey:@"token"];
    }else{
        [parameters setObject:customer_id forKey:@"customer_id"];
        
        [parameters setObject:token forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    
    NSString *currencyType=[defaults objectForKey:@"CurrentCurrency"];//设置货币类型
    if (currencyType.length == 0 || currencyType == nil){
        currencyType = [defaults objectForKey:@"CurrentCountry"];//系统货币类型
    }
    [parameters setObject:currencyType forKey:@"currency_type"];//商品货币类型
    
    [parameters setObject:self.currentPage forKey:@"page"];
    
    [parameters setObject:@"supportproductlist" forKey:@"req"];
    
//    NSLog(@"postParameter is %@", parameters );
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
        
        [MBPromptView hideLoading];
//        NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            NSDictionary *sDic = [responseBody objectForKey:@"data"];
            
            NSArray *pArr = [sDic objectForKey:@"productlist"];
            if (!self.isMore){
                [self.productArr removeAllObjects];
            }
            for (int i=0; i<pArr.count; i++){
                [self.productArr addObject:pArr[i]];
            }
            self.totalPage = [sDic objectForKey:@"total_page"];
            
            [self.GoodsListTable reloadData];
          
            if (self.productArr.count==0) {
                [self showNoProduct];
            }else{
                [self hideNoProduct];
            }
            
        }else{
            
            NSString *message = [responseBody objectForKey:@"message"];
            if (message != nil){
                [ZXZPromptView failWithDetail:message];
            }
        }
        
        [self.GoodsListTable.mj_footer endRefreshing];
        
    } failureBlock:^(NSString *error){
        
        [MBPromptView hideLoading];
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        [self.GoodsListTable.mj_footer endRefreshing];
    }];
    
}


@end
