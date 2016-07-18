//
//  leftViewController.m
//  BeiLu
//
//  Created by YKJ1 on 16/4/6.
//  Copyright © 2016年 YKJ1. All rights reserved.
//

#import "LeftViewController.h"
#import "PersonalTableViewCell.h"
#import "AvatarTableViewCell.h"
#import "UIViewController+MMDrawerController.h"
#import "HotWordView.h"

#import "ProductDetailViewController.h"
#import "MyInfomationViewController.h"
#import "NotificationViewController.h"
#import "ShoppingCartViewController.h"
#import "OrderHistoryViewController.h"
#import "CurrencyViewController.h"
#import "SettingViewController.h"
#import "WebViewController.h"
#import "SearchViewController.h"
#import "RichTextViewController.h"
#import "ContactTheSellerVC.h"

#define kHistoryTableViewTag 600
@interface LeftViewController ()<UITableViewDelegate, UITableViewDataSource,UISearchBarDelegate>
@property (strong, nonatomic) UISearchBar *searchBar;

@property (strong, nonatomic) UITableView *tableView;
@property (strong, nonatomic) NSArray *personalArr;
@property (strong, nonatomic) NSArray *personalNoArr;
@property (strong, nonatomic) NSArray *personalImageArr;

@property (strong, nonatomic) NSMutableArray *searchArr;
@property (strong, nonatomic) NSMutableArray *historySearchArr;

@property (strong, nonatomic)  NSString *oldName;

@property (strong, nonatomic) UITableView *historyTableView;
@property (strong, nonatomic) UITableView *searchTableView;

@property (assign, nonatomic) BOOL isLogin;

@property (assign, nonatomic) NSInteger nitifNum;
@property (assign, nonatomic) NSInteger cartNum;
@property (assign, nonatomic) NSInteger supportNum;

@property (strong, nonatomic) NSArray *hotArr;

@end

@implementation LeftViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    view.backgroundColor = [UIColor blackColor];
    [self.view addSubview:view];
    
    [self initData];
    self.isLogin = NO;
    
    self.searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth/3*2, 44)];
    self.searchBar.placeholder = ZDLocalizedString(@"Search", nil);
    self.searchBar.delegate = self;
    self.searchBar.backgroundColor = UIColorWithRGBA(69, 81, 92, 1);
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    for (UIView *view in self.searchBar.subviews) {
        for(UIView *subV in view.subviews){
            if([subV isKindOfClass:NSClassFromString(@"UISearchBarBackground")]){
                [subV removeFromSuperview];
                break;
            }
        }
        
    }
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTintColor:[UIColor whiteColor]];
    [[UIBarButtonItem appearanceWhenContainedIn: [UISearchBar class], nil] setTitle:ZDLocalizedString(@"Cancel", nil)];
    
    [self.view addSubview:self.searchBar];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth/3*2, kScreenHeight-64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = UIColorWithRGBA(69, 81, 92, 1);
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableFooterView = [[UIView alloc]init];
    [self.view addSubview:self.tableView];

    self.historyTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.historyTableView.delegate = self;
    self.historyTableView.dataSource = self;
    self.historyTableView.backgroundColor = UIColorWithRGBA(69, 81, 92, 1);
    self.historyTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.searchTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    self.searchTableView.delegate = self;
    self.searchTableView.dataSource = self;
    self.searchTableView.backgroundColor = UIColorWithRGBA(69, 81, 92, 1);
    self.searchTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.hotArr = [NSArray array];
    
}
-(UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.isLogin){
        self.isLogin = NO;
        [self.tableView reloadData];
    }
    //获取未读消息个数
    [self postPromptNum];
    //热门
    [self postHotSearch];
    
    [self.historySearchArr removeAllObjects];
    //历史搜索信息
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSArray *list = [defaults objectForKey:@"History"];
    for (int i=0; i<list.count; i++){
        [self.historySearchArr addObject:list[i]];
    }
    if (self.historySearchArr.count > 0){
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        header.backgroundColor = UIColorWithRGBA(89, 100, 117, 1);
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth, 30)];
        label.font = [UIFont systemFontOfSize:12];
        label.text = ZDLocalizedString(@"RecentSearches", nil);
        label.textAlignment = NSTextAlignmentLeft;
        label.textColor = [UIColor whiteColor];
        [header addSubview:label];
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(kScreenWidth-110, 0, 100, 30);
        [btn setTitle:ZDLocalizedString(@"ClearAll", nil) forState:UIControlStateNormal];
        btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        btn.titleLabel.font = [UIFont systemFontOfSize:12];
        [btn setTitleColor:UIColorWithRGBA(236, 95, 101, 1) forState:UIControlStateNormal];
        [header addSubview:btn];
        [btn addTarget:self action:@selector(clearAction) forControlEvents:UIControlEventTouchUpInside];
        
        self.historyTableView.tableHeaderView = header;
        [self.historyTableView reloadData];
    }
    
    NSUserDefaults *ssd = [NSUserDefaults standardUserDefaults];
    NSString *supportshow = [ssd objectForKey:@"SupportShow"];
    
    if ([supportshow isEqualToString:@"no"]){
        
        self.personalArr = @[AppName,@"",ZDLocalizedString(@"Browse", nil),ZDLocalizedString(@"Notifications", nil),ZDLocalizedString(@"ShoppingCart", nil),ZDLocalizedString(@"OrderHistory", nil),ZDLocalizedString(@"Currency", nil),@"",ZDLocalizedString(@"AboutUs", nil),ZDLocalizedString(@"ContactUs", nil),ZDLocalizedString(@"Settings", nil)];
        
        self.personalNoArr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @11];
        
        
        self.personalImageArr = @[@"",@"",@"browse",@"notifications",@"shoppingcart",@"orderhistory",@"currency",@"",@"aboutus",@"contactus",@"settings"];
        
        [self.tableView reloadData];
    }else {
        self.personalArr = @[AppName,@"",ZDLocalizedString(@"Browse", nil),ZDLocalizedString(@"Notifications", nil),ZDLocalizedString(@"ShoppingCart", nil),ZDLocalizedString(@"OrderHistory", nil),ZDLocalizedString(@"Currency", nil),@"",ZDLocalizedString(@"AboutUs", nil),ZDLocalizedString(@"ContactUs", nil),ZDLocalizedString(@"CustomerSupport", nil),ZDLocalizedString(@"Settings", nil)];
        
        self.personalNoArr = @[@0, @1, @2, @3, @4, @5, @6, @7, @8, @9, @10, @11];
        
        self.personalImageArr = @[@"",@"",@"browse",@"notifications",@"shoppingcart",@"orderhistory",@"currency",@"",@"aboutus",@"contactus",@"support",@"settings"];
        
        [self.tableView reloadData];
    }
    
}
- (void)clearAction {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:ZDLocalizedString(@"AreYouSure", nil) message:ZDLocalizedString(@"DYWTCAH", nil) delegate:self cancelButtonTitle:ZDLocalizedString(@"No", nil) otherButtonTitles:ZDLocalizedString(@"Yes", nil), nil];
    [alert showWithCompletion:^(UIAlertView *alertView, NSInteger buttonIndex) {
        if (buttonIndex == 1) {
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            [defaults removeObjectForKey:@"History"];
            [self.historySearchArr removeAllObjects];
            [self.historyTableView reloadData];
            self.historyTableView.tableHeaderView = nil;
        }
    }];
}

- (void) initData{
    _searchArr = [[NSMutableArray alloc] init];
    _historySearchArr = [[NSMutableArray alloc] init];
}
//搜索
- (void)startSearch {
    [self.searchBar becomeFirstResponder];
}
//开始搜索
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    if(self.searchBar.text.length == 0){
        self.searchBar.frame = CGRectMake(0, 20, kScreenWidth, 44);
        [self.searchBar setShowsCancelButton:YES animated:YES];
        [self.view addSubview:self.historyTableView];
        
        CGRect rect = self.tableView.frame;
        rect.size.width = kScreenWidth;
        self.tableView.frame = rect;
        [self.mm_drawerController setMaximumLeftDrawerWidth:kScreenWidth animated:YES completion:nil];
        [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeNone];
    }

}
//取消搜索
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    self.searchBar.frame = CGRectMake(0, 20, kScreenWidth*2/3, 44);
    [self.searchBar setShowsCancelButton:NO animated:YES];
    self.searchBar.text = @"";
    [self.searchBar resignFirstResponder];
    [self.historyTableView removeFromSuperview];
    [self.searchTableView removeFromSuperview];
    
    CGRect rect = self.tableView.frame;
    rect.size.width = kScreenWidth/3*2;
    self.tableView.frame = rect;
    [self.mm_drawerController setMaximumLeftDrawerWidth:kScreenWidth/3*2 animated:YES completion:nil];
    [self.mm_drawerController setCloseDrawerGestureModeMask:MMCloseDrawerGestureModeAll];
    
}
//搜索
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if([searchBar.text isEqualToString:@""]){
        [self.view addSubview:self.historyTableView];
        [self.searchTableView removeFromSuperview];
    }else{
        [self.view addSubview:self.searchTableView];
        [self.historyTableView removeFromSuperview];
    }
    self.oldName = self.searchBar.text;
    if (self.searchBar.text.length != 0){
        //用户停止输入0.3s后开始搜索匹配列表
        [self performSelector:@selector(searchPostList:) withObject:self.searchBar.text afterDelay:0.3];
    }
}

- (void) searchPostList:(NSString *) searchName{
    if ([self.oldName isEqualToString:searchName]){
        [self postSearchList:searchName];
    }
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    //edit your code
    //    NSLog(@"searchBar.text is %@", searchBar.text);
    [self initProductsView:searchBar.text];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if([tableView isEqual:self.searchTableView]){
        return [self.searchArr count];
    }else if([tableView isEqual:self.historyTableView]){
        return self.historySearchArr.count;
    }else{
        return self.personalArr.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if([tableView isEqual:self.searchTableView]){
        static NSString *cellId = @"UITableViewCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"search"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = self.searchArr[row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else if([tableView isEqual:self.historyTableView]){
        static NSString *cellId = @"UITableViewCell1";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.imageView.image = [UIImage imageNamed:@"search"];
        cell.textLabel.font = [UIFont systemFontOfSize:12];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.textLabel.text = self.historySearchArr[row];
        cell.backgroundColor = [UIColor clearColor];
        return cell;
    }else{
        
         NSInteger arrNo = [self.personalNoArr[row] integerValue];
        
        if (arrNo==0) {
            static NSString *cellId = @"AvatarTableViewCell";
            AvatarTableViewCell *cell = (AvatarTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"AvatarTableViewCell" owner:self options:nil] firstObject];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorWithRGBA(89, 100, 117, 1);
            
            //用户
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            NSString *avatarName = [defaults objectForKey:@"Username"];
            NSString *avatarUrl = [defaults objectForKey:@"Avatar"];
            
            NSString *customer_id =[defaults objectForKey:@"Userid"];
            NSString *token=[defaults objectForKey:@"Token"];
        
            NSNumber *gender = [defaults objectForKey:@"Gender"];
            if (0==customer_id.length || 0==token.length){
                
                cell.titleL.text = self.personalArr[row];//没有注册过时

                if ([gender integerValue] == 2){
                    [cell.imageV setImage:[UIImage imageNamed:@"female"]];
                }else if ([gender integerValue] == 1){
                    [cell.imageV setImage:[UIImage imageNamed:@"male"]];
                }else{
                    [cell.imageV setImage:[UIImage imageNamed:@"gender"]];
                }
                
            }else {
                if (0==avatarName.length){
                    cell.titleL.text = self.personalArr[row];//没有注册过时
                }else{
                    cell.titleL.text = avatarName;
                }
                
                NSString *str;
                if ([gender integerValue] == 2){
                    str = @"female";
                }else if ([gender integerValue] == 1){
                    str = @"male";
                }else{
                    str = @"gender";
                }
                [cell.imageV sd_setImageWithURL:[NSURL URLWithString:avatarUrl size:cell.imageV.frame.size] placeholderImage:[UIImage imageNamed:str] ];
            }
            
            return cell;
        }else if(arrNo==1||arrNo==7){
            static NSString *cellId = @"UITableViewCell2";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = UIColorWithRGBA(89, 100, 117, 1);
            return cell;
        }else{
            static NSString *cellId = @"PersonalTableViewCell";
            PersonalTableViewCell *cell = (PersonalTableViewCell *)[tableView dequeueReusableCellWithIdentifier:cellId];
            if (!cell) {
                cell = [[[NSBundle mainBundle] loadNibNamed:@"PersonalTableViewCell" owner:self options:nil] firstObject];
            }
            cell.backgroundColor = [UIColor clearColor];
            cell.imageV.image = [UIImage imageNamed:self.personalImageArr[row]];
            cell.titleL.text = self.personalArr[row];
            cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
            cell.selectedBackgroundView.backgroundColor = UIColorWithRGBA(89, 100, 117, 1);
            
            cell.numberL.hidden = YES;
            if (arrNo == 3){
                if (self.nitifNum != 0) {
                    cell.numberL.hidden = NO;
                    cell.numberL.text = [NSString stringWithFormat:@"%lu",(long)self.nitifNum];
                }else{
                    cell.numberL.hidden = YES;
                }
            }
            if (arrNo == 4){
                if (self.cartNum > 0) {
                    cell.numberL.hidden = NO;
                    cell.numberL.text = [NSString stringWithFormat:@"%lu", (long)self.cartNum];
                }else{
                    cell.numberL.hidden = YES;
                }
            }
            
            if (arrNo == 10) {
                if (self.supportNum > 0) {
                    cell.numberL.hidden = NO;
                    cell.numberL.text = [NSString stringWithFormat:@"%lu", (long)self.supportNum];
                }else{
                    cell.numberL.hidden = YES;
                }
            }
            
            if (arrNo==6 || row==self.personalArr.count-1) {
                cell.lineV.hidden = YES;
            }
            
            return cell;
            
        }
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSInteger row = indexPath.row;
    if([tableView isEqual:self.searchTableView]){
        return 44;
    }else if([tableView isEqual:self.historyTableView]){
        return 44;
    }else{
        if (row==0) {
            return 50;
        }else if(row==1||row==7){
            return 5;
        }else{
            return 44;
        }
    }
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSInteger row = indexPath.row;
    if([tableView isEqual:self.searchTableView]||[tableView isEqual:self.historyTableView]){
        [self.view endEditing:YES];
        if ([tableView isEqual:self.searchTableView]){
            //搜索结果，点击后跳转到商品搜索界面
            [self initProductsView:self.searchArr[row]];
            
        }else{
            //历史搜索，点击后跳转到商品搜索界面
            [self initProductsView:self.historySearchArr[row]];
        }
        
    }else{
        NSInteger arrNo = [self.personalNoArr[row] integerValue];

        switch (arrNo) {
            case 0:
            {
                //用户id
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *customer_id = [defaults objectForKey:@"Userid"];
                NSString *token=[defaults objectForKey:@"Token"];
                if (0==customer_id.length || 0==token.length){
                    //未登录时弹出登录界面
                    [self showLoginView];
                    self.isLogin = YES;
                }else{
                    MyInfomationViewController *myInfomationVC = [[MyInfomationViewController alloc] init];
                    myInfomationVC.navigationItem.title = self.personalArr[row];
                    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [nav pushViewController:myInfomationVC animated:NO];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                }
            }
                break;
            case 2:
            {
                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav popToRootViewControllerAnimated:NO];
            }
                break;
            case 3:
            {
                //用户id
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *customer_id = [defaults objectForKey:@"Userid"];
                NSString *token=[defaults objectForKey:@"Token"];
                if (0==customer_id.length || 0==token.length){
                    //未登录时弹出登录界面
                    [self showLoginView];
                    self.isLogin = YES;
                }else{
                    NotificationViewController *notificationVC = [[NotificationViewController alloc] init];
                    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [nav pushViewController:notificationVC animated:NO];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                    
                }
                
            }
                break;
            case 4:
            {
                //用户id
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *customer_id = [defaults objectForKey:@"Userid"];
                NSString *token=[defaults objectForKey:@"Token"];
                if (0==customer_id.length || 0==token.length){
                    //未登录时弹出登录界面
                    [self showLoginView];
                    self.isLogin = YES;
                }else{
                    //购物车
                    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                    
                    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                    
                    
                    //购物车界面
                    ShoppingCartViewController *shoppingCartVC = [[ShoppingCartViewController alloc] init];
                    
                    UINavigationController *newnav =[[UINavigationController alloc] initWithRootViewController:shoppingCartVC];
                    newnav.navigationBar.hidden = YES;
                    newnav.modalPresentationStyle=UIModalPresentationOverCurrentContext;
                    [nav presentViewController:newnav animated:YES completion:nil];
                    
                }
                
            }
                break;
            case 5:
            {
                //用户id
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *customer_id = [defaults objectForKey:@"Userid"];
                NSString *token=[defaults objectForKey:@"Token"];
                if (0==customer_id.length || 0==token.length){
                    //未登录时弹出登录界面
                    [self showLoginView];
                    self.isLogin = YES;
                }else{
                    OrderHistoryViewController *orderHistoryVC = [[OrderHistoryViewController alloc] init];
                    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [nav pushViewController:orderHistoryVC animated:NO];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                }
            }
                break;
            case 6:
            {
                CurrencyViewController *currencyVC = [[CurrencyViewController alloc] init];
                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav pushViewController:currencyVC animated:NO];
                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
                
                //                WalletViewController *walletVC = [[WalletViewController alloc] init];
                //                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                //                [nav pushViewController:walletVC animated:NO];
                //                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            }
                break;
            case 8:
            {
                RichTextViewController *richTextVC = [[RichTextViewController alloc] init];
                richTextVC.reqUrl = @"aboutus";
                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav pushViewController:richTextVC animated:NO];
                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            }
                break;
            case 9:
            {
                RichTextViewController *richTextVC = [[RichTextViewController alloc] init];
                richTextVC.reqUrl = @"contactus";
                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                [nav pushViewController:richTextVC animated:NO];
                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            }
                break;
            case 10:
            {
//                RichTextViewController *richTextVC = [[RichTextViewController alloc] init];
//                richTextVC.reqUrl = @"customersupport";
//                UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
//                [nav pushViewController:richTextVC animated:NO];
//                [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
            
                
                NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
                NSString *customer_id = [defaults objectForKey:@"Userid"];
                NSString *token=[defaults objectForKey:@"Token"];
                if (0==customer_id.length || 0==token.length){
                    
                    //未登录时弹出登录界面
                    [self showLoginView];
                    
                }else{
                    
                    //客户支持
                    ContactTheSellerVC *contactVC = [[ContactTheSellerVC alloc] init];
                    UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
                    [nav pushViewController:contactVC animated:NO];
                    [self.mm_drawerController closeDrawerAnimated:YES completion:nil];

                }

            }
                break;
            case 11:
            {
                SettingViewController *settingVC = [[SettingViewController alloc] init];
                [self.navigationController pushViewController:settingVC animated:YES];
            }
                break;
            default:
                break;
        }
    }
}


- (void) initProductsView:(NSString *) searchName{
    
    NSString *searchText = [searchName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
  
    if (searchText.length != 0 && searchText != nil){
        self.searchBar.text = searchText;
        
        
        [self.view endEditing:YES];
        SearchViewController *searchVC = [[SearchViewController alloc] init];
        searchVC.searchName = searchText;
        searchVC.searchText = searchText;
        searchVC.isHome = NO;
        UINavigationController *nav = (UINavigationController*)self.mm_drawerController.centerViewController;
        [nav pushViewController:searchVC animated:NO];
        [self.mm_drawerController closeDrawerAnimated:YES completion:nil];
    }

}

#pragma mark --postPromptNum
//获取未读消息个数
- (void)postPromptNum{
    
    //    NSDictionary *dict = @{
    //                           @"status" : @1,
    //                           @"message" : @"testst",
    //                           @"data" :@{
    //                                       @"notifnum" : @1,
    //                                       @"cartnum" : @999,
    //                                    }
    //                           };
    //    //  NSLog(@"dict is%@", dict);
    //
    //    NSDictionary *sDic = [dict objectForKey:@"data"];
    //
    //    self.nitifNum = [sDic objectForKey:@"notifnum"];
    //    self.cartNum = [sDic objectForKey:@"cartnum"];
    //    if ([self.nitifNum integerValue] > 0 || [self.cartNum integerValue] > 0){
    //        [self.tableView reloadData];
    //    }
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id =[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    if (customer_id.length != 0 && token.length != 0){
        [parameters setObject:customer_id forKey:@"customer_id"];
        [parameters setObject:token forKey:@"token"];
    }else{
        [parameters setObject:@"" forKey:@"customer_id"];
        [parameters setObject:@"" forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    [parameters setObject:@"PromptNum" forKey:@"req"];
    
    //        NSLog(@"parameters is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
        
        //            NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            
            NSDictionary *sDic = [responseBody objectForKey:@"data"];
            
            self.nitifNum = [sDic[@"notifnum"] integerValue];
            self.cartNum = [sDic[@"cartnum"] integerValue];
            self.supportNum = [sDic[@"supportnum"] integerValue];
            //"supportnum":9客户咨询未读消息个数
            [self.tableView reloadData];
            
        }
        
    } failureBlock:^(NSString *error){
        
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
    }];
    
    
}


#pragma mark --postSearchList
//获取搜索匹配名称
- (void)postSearchList:(NSString*)searchName{
    //        NSLog(@"searchName is %@", searchName);
    //    NSDictionary *dict = @{
    //                           @"status" : @1,
    //                           @"message" : @"testst",
    //                           @"data" :@{
    //                                   @"searchlist" : @[
    //                                           @{
    //                                               @"name" : @"glass cat"
    //                                               },
    //
    //                                           @{
    //                                               @"name" : @"glass red"
    //                                               },
    //                                           @{
    //                                               @"name" : @"glass bold"
    //                                               },
    //                                           @{
    //                                               @"name" : @"glass black"
    //                                               },
    //                                           @{
    //                                               @"name" : @"glass little"
    //                                               },
    //                                           @{
    //                                               @"name" : @"glass left"
    //                                               },
    //                                           @{
    //                                               @"name" : @"glass right"
    //                                               }
    //                                    ],
    //
    //                                   }
    //                           };
    //    //  NSLog(@"dict is%@", dict);
    //
    //    NSNumber *status = [dict objectForKey:@"status"];
    //    NSNumber *s= [NSNumber numberWithInt:1];
    //
    //
    //    if ([status isEqualToNumber:s]){
    //         [self.searchArr removeAllObjects];
    //
    //        NSDictionary *sDic = [dict objectForKey:@"data"];
    //
    //        NSArray *sList = [sDic objectForKey:@"searchlist"];
    //
    //        for (int i=0; i<sList.count; i++){
    //
    //            NSString *name = [sList[i] objectForKey:@"name"];
    //            if (name.length != 0){
    //
    //                [self.searchArr addObject:name];
    //
    //            }
    //        }
    //        [self.searchDisplayController.searchResultsTableView reloadData];
    //    }
    //     NSLog(@"self.searchArr is %@", self.searchArr);
    
    
    
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id =[defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    if (customer_id.length != 0 && token.length != 0){
        [parameters setObject:customer_id forKey:@"customer_id"];
        [parameters setObject:token forKey:@"token"];
    }else{
        [parameters setObject:@"" forKey:@"customer_id"];
        [parameters setObject:@"" forKey:@"token"];
    }
    [parameters setObject:searchName forKey:@"search_content"];
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    [parameters setObject:@"searchlist" forKey:@"req"];
    
    
    
    //    NSLog(@"parameters is %@", parameters);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
        
        //        NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        
        if ([status isEqualToNumber:s]){
            [self.searchArr removeAllObjects];
            
            NSDictionary *sDic = [responseBody objectForKey:@"data"];
            
            NSArray *sList = [sDic objectForKey:@"searchlist"];
            
            for (int i=0; i<sList.count; i++){
                NSString *name = sList[i];
                if (name.length != 0){
                    [self.searchArr addObject:name];
                }
            }

            [self.searchTableView reloadData];
        
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

//获取热门搜索列表
- (void)postHotSearch{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    //用户id
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSString *customer_id = [defaults objectForKey:@"Userid"];
    NSString *token=[defaults objectForKey:@"Token"];
    
    if (customer_id.length != 0 && token.length != 0){
        [parameters setObject:customer_id forKey:@"customer_id"];
        [parameters setObject:token forKey:@"token"];
    }else{
        [parameters setObject:@"" forKey:@"customer_id"];
        [parameters setObject:@"" forKey:@"token"];
    }
    
    [parameters setObject:[MainViewManager languageStye] forKey:@"languages"];
    [parameters setObject:@"hotsearchlist" forKey:@"req"];
    //    NSMutableDictionary *postParameter = [NSMutableDictionary dictionary];
    //    NSString *Pstring = [parameters mj_JSONString];
    //    [postParameter setObject:Pstring forKey:@"handler"];
    
    //    NSLog(@"postParameter is %@", postParameter);
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kAPPHANDLER_URL successBlock:^(id responseBody){
        
        //    NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            NSDictionary *sDic = [responseBody objectForKey:@"data"];
            self.hotArr = sDic[@"searchlist"];
            if (self.hotArr.count>0) {
                HotWordView *hotView = [[HotWordView alloc] initWithData:self.hotArr];
                hotView.frame = CGRectMake(0, 0, kScreenWidth, 250);
                self.historyTableView.tableFooterView = hotView;
                hotView.hotBlock = ^(NSInteger idx){
                    [self initProductsView:self.hotArr[idx]];
                };
            }
        }
        
    } failureBlock:^(NSString *error){
        
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
    }];
}

@end
