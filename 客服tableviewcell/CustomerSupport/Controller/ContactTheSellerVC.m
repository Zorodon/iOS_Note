//
//  ContactTheSellerVC.m
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import "ContactTheSellerVC.h"
#import "GoosListViewController.h"
#import "ServicesTableViewCell.h"
#import "UserMessageTableViewCell.h"
#import "ProductlinksCell.h"
#import "ProductDetailViewModel.h"
#import "CustomerSupportModel.h"
#import "ProductDetailViewController.h"

static NSString*CustomCell=@"CustomCell";
static NSString*CustomUserCell=@"CustomUserCell";
static NSString*ProductCell=@"ProductCell";

#define kChatViewHeight 50

@interface ContactTheSellerVC ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIScrollViewDelegate>
{
    UIImageView*_icon;
    UILabel*_content_lb;
    UILabel*_price_lb;
    UILabel*_money_lb;
    UIView*_backgroundView;  //头部产品资料
    
    UIView*_systeMessageView;
}
@property(nonatomic, strong)UITableView*chatTable;

@property(nonatomic, strong)NSMutableArray*supportArr;
@property(nonatomic, strong)NSString *oldTime;

@property(nonatomic, strong) NSNumber *supportNum;//未读消息数
@property(nonatomic, strong) NSString *systTitle;//系统提示标题
@property(nonatomic, strong) NSString *dateTitle;//发送系统提示标题时间

@property (nonatomic, strong)UIView *views; //底部输入视图
@property (nonatomic, strong)UITextField *textTF;
@property (nonatomic ,strong)UIActivityIndicatorView* activity;
@property (nonatomic ,strong)UIView* activityView;
@property (nonatomic, assign) BOOL isActivityShow;

@property (nonatomic, assign) BOOL isSend;

@property (nonatomic, strong) NSTimer *supportTimer;//定时读取新信息
@property (nonatomic, strong) UIButton *messageBtn;//新消息按钮
@property (nonatomic, strong) UILabel *messageL;//未读消息
@property (nonatomic, assign) BOOL isSendLink;//是否已经发送链接
@property (nonatomic, assign) BOOL isSysMessage;//是否显示系统消息

@property (nonatomic, assign) CGFloat lastContentOffset;

@end

@implementation ContactTheSellerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=ZDLocalizedString(@"CustomerSupport", nil);
    self.view.backgroundColor=[UIColor whiteColor];
    if (self.productArr.count>0) {
        self.isSendLink = YES;
    }
    self.isSysMessage = YES;
    
    //底部输入框
    [self creatTextFiledView];
    //历史查看提示
    [self initChatTableView];
    self.isActivityShow = NO;
    //消息界面
    [self createMessageView];
    //加载数据
    [self initData];
    //导航栏按钮
    [self createNavRightBtn];
    

}
- (void)initData{
    
    _supportArr = [[NSMutableArray alloc] init];
    self.oldTime = @"0";
    self.systTitle = @"";
    self.dateTitle = @"";
    //第一进入消息界面时调用
    [MBPromptView showLoading];
    [self postNewSupport:@"new" newsId:@"0"];
}

#pragma mark   导航栏按钮
-(void)createNavRightBtn{
    UIBarButtonItem*rightBtn=[[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"history"] style:UIBarButtonItemStylePlain target:self action:@selector(checkRecord)];
    self.navigationController.navigationBar.tintColor=[UIColor whiteColor];
    self.navigationItem.rightBarButtonItem=rightBtn;
}
-(void)checkRecord{
    [self.navigationController pushViewController:[GoosListViewController new] animated:YES];
}

#pragma mark =====================  聊天视图  指示器 =======================
-(void)initChatTableView{
    self.chatTable=[[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    _chatTable.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.views.bounds.size.height-64);
    _chatTable.backgroundColor=[UIColor groupTableViewBackgroundColor];
    _chatTable.delegate=self;
    _chatTable.dataSource=self;
    _chatTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_chatTable];
    [self.view sendSubviewToBack:_chatTable];
    
    _activityView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    _activityView.backgroundColor=[UIColor clearColor];
    //表头视图 指示器
    _activity  = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake((kScreenWidth-30)/2, 20, 30, 30)];
    _activity.backgroundColor=[UIColor clearColor];
    _activity.activityIndicatorViewStyle=UIActivityIndicatorViewStyleGray;
    _activity.hidesWhenStopped=YES;
//    _chatTable.tableHeaderView=_activity;
    [_activityView addSubview:_activity];
    
    [_chatTable registerClass:[ServicesTableViewCell class] forCellReuseIdentifier:CustomCell];
    [_chatTable registerClass:[UserMessageTableViewCell class] forCellReuseIdentifier:CustomUserCell];
    [_chatTable registerClass:[ProductlinksCell class] forCellReuseIdentifier:ProductCell];  //发送链接
}
-(void)createSectionHeaderView{   //第一个区 区头视图产品链接
    ProductDetailViewModel *productData= [ProductDetailViewModel mj_objectWithKeyValues:self.productArr[0]];
    
    _backgroundView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    _backgroundView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    UIView*v=[[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [_backgroundView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_backgroundView.mas_top).offset(10);
        make.left.equalTo(_backgroundView.mas_left).offset(10);
        make.bottom.equalTo(_backgroundView.mas_bottom).offset(-10);
        make.right.equalTo(_backgroundView.mas_right).offset(-10);
    }];
    
    //小图标
    _icon=[[UIImageView alloc]initWithFrame:CGRectZero];
    
    //    _icon.backgroundColor=[UIColor redColor];
    [_backgroundView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_top).offset(10);
        make.left.equalTo(v.mas_left).offset(10);
        make.bottom.equalTo(v.mas_bottom).offset(-10);
        make.width.equalTo(@64);
    }];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    
    NSString *url = @" ";
    if (productData.thumb.count > 0){
        url = productData.thumb[0];
    }
    [_icon sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"refresh1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            _icon.image = [UIImage imageNamed:@"photofail"];
        }else {
            //将imageView的背景颜色设置为图片左边中间一个像素点的颜色
            _icon.backgroundColor = [MainViewManager getImageEdgeColor:image];
        }
    }];
    
    
    //小标题
    _content_lb=[[UILabel alloc]initWithFrame:CGRectZero];
    _content_lb.text=productData.name;//商品名称
    
    _content_lb.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    _content_lb.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:14];
    _content_lb.textAlignment=NSTextAlignmentLeft;
    [_backgroundView addSubview:_content_lb];
    [_content_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_top).offset(10);
        make.right.equalTo(v.mas_right).offset(-10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    
    
    //特价
    _price_lb=[[UILabel alloc]initWithFrame:CGRectZero];
    //    _price_lb.text=@"京东价：京东价京东价京东价";
    _price_lb.textColor=[UIColor colorWithRed:128/255 green:128/255 blue:128/255 alpha:1];
    _price_lb.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:13];
    _price_lb.textAlignment=NSTextAlignmentLeft;
    [_backgroundView addSubview:_price_lb];
    [_price_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_content_lb.mas_bottom).offset(7);
        //make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    //原价
    _money_lb=[[UILabel alloc]initWithFrame:CGRectZero];
    //    _money_lb.text=@"$520";
    _money_lb.font=[UIFont fontWithName:kDefaultAppFontTypeName  size:11];
    _money_lb.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
    _money_lb.textAlignment=NSTextAlignmentLeft;
    [_backgroundView addSubview:_money_lb];
    [_money_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price_lb.mas_centerY);
        make.left.equalTo(_price_lb.mas_right).offset(5);
    }];
    
    if (productData.special == nil){
        
        _price_lb.text = productData.price;
        _money_lb.hidden = YES;
        
    }else {
        
        _price_lb.text = productData.special;
        [_money_lb setStrickoutString:productData.price];
        if ([productData.price isEqualToString:productData.special]) {
            _money_lb.hidden = YES;
        }else{
            _money_lb.hidden = NO;
        }
    }
    
    //按钮
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectZero];
    btn.backgroundColor=[UIColor colorWithRed:220/255.0 green:72/255.0 blue:60/255.0 alpha:1.0];
    btn.layer.cornerRadius=2;
    btn.titleLabel.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:11];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];

    [btn setTitle:ZDLocalizedString(@"SendALink", nil) forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendlink) forControlEvents:UIControlEventTouchUpInside];

    [_backgroundView addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_price_lb.mas_bottom).offset(5);
        make.left.equalTo(_icon.mas_right).offset(10);
        make.height.equalTo(@20);
        make.width.equalTo(@80);
    }];
}

// 发送链接
-(void)sendlink{
    self.isSendLink = NO;
    ProductDetailViewModel *productData= [ProductDetailViewModel mj_objectWithKeyValues:self.productArr[0]];
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr lastObject]];
    
    [self postSendSupport:@"product" newsId:[NSString stringWithFormat:@"%lu",(long)[supportData.news_id integerValue]] content:[NSString stringWithFormat:@"%lu",[productData.product_id integerValue]]];
}

#pragma mark tableView  delegate && dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return  self.supportArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [self getHeightWithRow:indexPath.row];
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (self.isSendLink){
        if (self.isSysMessage) {
            return 140+[self getSizeWithAttributedString:[self adjustmentLineSpacing:self.systTitle?:@""]].height;
        }else{
            return 110;
        }
    }else{
        if (self.isSysMessage) {
            return 50+[self getSizeWithAttributedString:[self adjustmentLineSpacing:self.systTitle?:@""]].height;
        }else{
            return 20;
        }
    }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    CGFloat height ,systeMessageViewY;
    if (self.isSendLink) {
        height=160;
        systeMessageViewY=90;
    }else{
        height=70;
        systeMessageViewY=0;
    }
    
    UIView*sectionHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, height)];
    
    if (self.isSendLink){
        [self createSectionHeaderView];
        [sectionHeader addSubview:_backgroundView];
    }
    
    if (self.isSysMessage) {
        CGFloat height= [self getSizeWithAttributedString:[self adjustmentLineSpacing:self.systTitle?:@""]].height+50;
//        NSLog(@"---%f",height);
        _systeMessageView=[[UIView alloc]initWithFrame:CGRectMake(0, systeMessageViewY, kScreenWidth, height)];
        _systeMessageView.backgroundColor=[UIColor groupTableViewBackgroundColor];
        [sectionHeader addSubview:_systeMessageView];
        
        UIView*v2=[[UIView alloc]initWithFrame:CGRectZero];
        v2.backgroundColor=[UIColor whiteColor];
        [_systeMessageView addSubview:v2];
        [v2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_systeMessageView.mas_top).offset(10);
            make.left.equalTo(_systeMessageView.mas_left).offset(10);
            make.bottom.equalTo(_systeMessageView.mas_bottom).offset(-10);
            make.right.equalTo(_systeMessageView.mas_right).offset(-10);
        }];
        
        //小标题
        UILabel* content=[[UILabel alloc]initWithFrame:CGRectZero];
        
        content.text=[NSString stringWithFormat:@"%@ ( %@ )",ZDLocalizedString(@"SystemInformation", nil),  [MainViewManager showDateMode:self.dateTitle type:@"hour"]];
        
        content.font=[UIFont fontWithName:kDefaultAppFontTypeName  size:12];
        content.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        content.textAlignment=NSTextAlignmentLeft;
        [_systeMessageView addSubview:content];
        [content mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(v2.mas_top).offset(10);
            make.left.equalTo(v2.mas_left).offset(10);
        }];
        
        //小标题
        UILabel*message=[[UILabel alloc]initWithFrame:CGRectZero];
        
        message.attributedText=[self adjustmentLineSpacing:self.systTitle?:@""];
        
        message.numberOfLines=0;
        message.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
        message.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:13];
        message.textAlignment=NSTextAlignmentLeft;
        [_systeMessageView addSubview:message];
        [message mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(content.mas_bottom).offset(5);
            make.right.equalTo(v2.mas_right).offset(-10);
            make.left.equalTo(v2.mas_left).offset(10);
        }];
        
        UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
        [_systeMessageView addGestureRecognizer:pan];
    }
    return sectionHeader;
}

- (void)panAction:(UIPanGestureRecognizer *)gesture {
    CGPoint translation = [gesture translationInView:self.view];
    if (translation.x<-20) {
        CGRect rect = _systeMessageView.frame;
        rect.origin.x = -kScreenWidth;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _systeMessageView.frame = rect;
        } completion:nil];
        self.isSysMessage = NO;
    }
    if (translation.x>20) {
        CGRect rect = _systeMessageView.frame;
        rect.origin.x = kScreenWidth;
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _systeMessageView.frame = rect;
        } completion:nil];
        self.isSysMessage = NO;
    }
    
    [gesture setTranslation:CGPointMake(0, 0) inView:self.view];
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:self.supportArr[indexPath.row]];

    NSString *showTime = [self showTimeWithRow:indexPath.row];
    if ([supportData.type isEqualToString:@"content"]) {
        if ([supportData.newstype isEqualToString:@"seller"]) {
            //客服
            ServicesTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:CustomCell];
            cell.selectionStyle=UITableViewCellSelectionStyleNone;
            //赋值， 图片 文字
            [cell setMessageLabelValue:supportData.content andImage:supportData.avatar gender:supportData.gender time:showTime];
            return cell;
            
        }else{
            //用户
            UserMessageTableViewCell*Usercell=[tableView dequeueReusableCellWithIdentifier:CustomUserCell];
            Usercell.selectionStyle=UITableViewCellSelectionStyleNone;
            //赋值， 图片 文字
            [Usercell setUserMessageLabelValue:supportData.content andImage:supportData.avatar gender:supportData.gender time:showTime];
            return Usercell;
        }
    }else {

        ProductlinksCell*Productcell=[tableView dequeueReusableCellWithIdentifier:ProductCell];
        Productcell.selectionStyle=UITableViewCellSelectionStyleNone;
        [Productcell setProductData:supportData.product newsType:supportData.newstype andImage:supportData.avatar Gender:supportData.gender];
        return Productcell;
    }
}

- (NSString *)showTimeWithRow:(NSInteger )row {
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:self.supportArr[row]];

    if (row > 0){
        SupportModel *oldData= [SupportModel mj_objectWithKeyValues:self.supportArr[row-1]];
        self.oldTime = oldData.date_added ;
    }else {
        self.oldTime = @"0";
    }
    
    NSString *showTime = @"";
    if ( ([supportData.date_added intValue] - [self.oldTime intValue]) > 60 ){
        showTime = [MainViewManager showDateMode:supportData.date_added type:@"minute"];
    }
    return showTime;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.view endEditing:YES];
    
    
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:self.supportArr[indexPath.row]];
    
    if ([supportData.type isEqualToString:@"product"] && supportData.product.product_id != nil) {
        ProductDetailViewController *productDetailVC = [[ProductDetailViewController alloc] init];
        productDetailVC.productId = supportData.product.product_id;
        productDetailVC.producttitle = supportData.product.title;
        [self.navigationController pushViewController:productDetailVC animated:YES];
    }

}

#pragma mark  ===================  底部输入框  ===============================
-(void)creatTextFiledView{
    self.views=[[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight-64-kChatViewHeight, kScreenWidth, kChatViewHeight)];
    self.views.backgroundColor=[UIColor lightGrayColor];
    [self.view addSubview:self.views];
    
    UITextField*textTF=[[UITextField alloc]initWithFrame:CGRectZero];
    textTF.returnKeyType = UIReturnKeySend;
    textTF.borderStyle=UITextBorderStyleRoundedRect;
    textTF.placeholder=ZDLocalizedString(@"PleaseEnterText", nil);
    textTF.delegate=self;
    [self.views addSubview:textTF];
    self.textTF=textTF;
    [textTF mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.views.mas_top).offset(7);
        make.left.equalTo(self.views.mas_left).offset(10);
        make.bottom.equalTo(self.views.mas_bottom).offset(-7);
        make.right.equalTo(self.views.mas_right).offset(-50);
    }];
    
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectZero];
    [btn setBackgroundImage:[UIImage imageNamed:@"contactsend"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(sendBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.views addSubview:btn];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.views.mas_centerY);
        make.right.mas_equalTo(self.views).offset(-10);
        make.width.mas_equalTo(30);
        make.height.mas_equalTo(30);
    }];
}

- (void)createMessageView {
    //新消息弹窗
    self.messageBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.messageBtn setBackgroundImage:[UIImage imageNamed:@"shape12"] forState:UIControlStateNormal];
    [self.messageBtn setTitle:ZDLocalizedString(@"NewMessage", nil) forState:UIControlStateNormal];
    [self.messageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.messageBtn.titleLabel.font = [UIFont fontWithName:kDefaultAppFontTypeName  size:14];
    self.messageBtn.titleEdgeInsets = UIEdgeInsetsMake(-10, 0, 0, 0);
    [self.messageBtn addTarget:self action:@selector(messageAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.messageBtn];
    self.messageBtn.hidden = YES;
    
    NSString *str = ZDLocalizedString(@"NewMessage", nil);
    UIFont *font = [UIFont fontWithName:kDefaultAppFontTypeName  size:14];
    NSDictionary * tDic = @{NSFontAttributeName:font};
    CGRect rect = [str boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 40)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:tDic
                                    context:nil];
    CGFloat width = rect.size.width+20;
    
    [self.messageBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(-kChatViewHeight-2);
        make.right.mas_equalTo(-15);
        make.width.mas_equalTo(width);
        make.height.mas_equalTo(40);
    }];
    
    //未读消息
    self.messageL = [[UILabel alloc]init];
    self.messageL.textAlignment = NSTextAlignmentCenter;
    self.messageL.backgroundColor = [UIColor colorWithRed:220/255.0 green:72/255.0 blue:60/255.0 alpha:1.0];
    self.messageL.textColor = [UIColor whiteColor];
    self.messageL.font = [UIFont fontWithName:kDefaultAppFontTypeName  size:14];
    [self.view addSubview:self.messageL];
    self.messageL.hidden = YES;
    
    [self.messageL mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(25);
    }];
    
}
//新消息滑动到最底下
- (void)messageAction {
    if (self.chatTable.contentSize.height>self.chatTable.bounds.size.height) {
        [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:YES];
    }
    self.messageBtn.hidden = YES;
}
#pragma mark 发送按钮
- (void)sendBtnAction:(id)sender {
    [self.textTF resignFirstResponder];
    if (self.textTF.text.length==0) {
        return;
    }
    
    //发送内容
    self.isSend = YES;
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr lastObject]];
    [self postSendSupport:@"content" newsId:[NSString stringWithFormat:@"%lu",(long)[supportData.news_id integerValue]] content:self.textTF.text];
    
}

//定时读取聊天数据
- (void)supportTimerAction {
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr lastObject]];
    [self postNewSupport:@"new" newsId:[NSString stringWithFormat:@"%lu",(long)[supportData.news_id integerValue]]];
}

//通知绑定方法 修改键盘 tableview 坐标大小
- (void)handleKeyBoardAction:(NSNotification *)notification {
    CGRect beginFrame = [notification.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endFrame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat detalY = endFrame.origin.y - beginFrame.origin.y;
    
    CGFloat frame = self.views.frame.origin.y;
    frame += detalY;
    self.views.frame = CGRectMake(0, frame, self.view.frame.size.width, kChatViewHeight);
    
    if (detalY>0) {
        _chatTable.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.views.bounds.size.height-64);
    }else{
        _chatTable.frame=CGRectMake(0, 0, kScreenWidth, kScreenHeight-self.views.bounds.size.height-64+detalY);
        //NSLog(@"%f",detalY);
    }
//    if (self.supportArr.count>0) {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.supportArr.count-1 inSection:0];
//        [self.chatTable scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//    }
    if (self.chatTable.contentSize.height>self.chatTable.bounds.size.height) {
        [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:YES];
    }

}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if (self.textTF.text.length==0) {
        return NO;
    }else{
        [self.textTF resignFirstResponder];
        //发送内容
        self.isSend = YES;
        SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr lastObject]];
        [self postSendSupport:@"content" newsId:[NSString stringWithFormat:@"%lu",(long)[supportData.news_id integerValue]] content:self.textTF.text];
        return YES;
    }

}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
    if (str.length>1000) {
        return NO;
    }else{
        return YES;
    }
}

//计算字体高度
-(CGFloat )getHeightWithRow:(NSInteger )row{
    SupportModel *supportData= [SupportModel mj_objectWithKeyValues:self.supportArr[row]];
    CGFloat height;
    if ([supportData.type isEqualToString:@"content"]) {
        NSString *showTime = [self showTimeWithRow:row];
        if (showTime.length==0) {
            height= [self getSizeWithAttributedString:[self adjustmentLineSpacing:supportData.content]].height+40;
        }else{
            height= [self getSizeWithAttributedString:[self adjustmentLineSpacing:supportData.content]].height+70;
        }
    }else if ([supportData.type isEqualToString:@"product"]){
        height=140;
    }
    return height;
}
-(CGSize)getSizeWithAttributedString:(NSAttributedString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}

#pragma mark 调整字体 行间距
-(NSMutableAttributedString*)adjustmentLineSpacing:(NSString*)content{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kDefaultAppFontTypeName  size:14] range:NSMakeRange(0, [content length])];
    
    return attributedString;
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleKeyBoardAction:) name:UIKeyboardWillHideNotification object:nil];
    
    [[IQKeyboardManager sharedManager] setEnable:NO];
    
    if (self.supportTimer) {
        [self.supportTimer setFireDate:[NSDate date]];
    }
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
    [[IQKeyboardManager sharedManager] setEnable:YES];
    [self.supportTimer setFireDate:[NSDate distantFuture]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark =========================== RefreshTableView ==========================
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (_chatTable.contentOffset.y<-30) {
         SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr firstObject]];
        NSInteger oldId= [supportData.rowid integerValue];
//        NSLog(@"oldId is %ld",oldId);
        if (oldId > 1){
            if (!_isActivityShow){
                
                [self.supportTimer setFireDate:[NSDate distantFuture]];
                //菊花开始
                _chatTable.tableHeaderView=_activityView;
                [_activity startAnimating];
                self.isActivityShow = YES;
            }
        }
    }
    
    if (self.chatTable.contentOffset.y>=self.chatTable.contentSize.height-self.chatTable.bounds.size.height) {
        self.messageBtn.hidden = YES;
    }
    self.messageL.hidden = YES;
    
}

//完成拖拽
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate;{
  
    if (self.isActivityShow){
        SupportModel *supportData= [SupportModel mj_objectWithKeyValues:[self.supportArr firstObject]];
        [self postNewSupport:@"old" newsId:[NSString stringWithFormat:@"%lu",(long)[supportData.news_id integerValue]]];
    }

}


#pragma mark --postNewSupport
//获取消息
- (void)postNewSupport:(NSString *)type newsId:(NSString *)newsId{
    
    //
    //        NSDictionary *dict = @{
    //                               @"status" : @1,
    //                               @"message" : @"testst",
    //                               @"data":@{
    //                                       @"num":@0,
    //                                       @"title": @"Hello Michael Kors",
    //                                       @"date_added" :@1467685153,
    //                                       @"support" : @[
    //                                               @{
    //                                                   @"author":@"Sam Chen",
    //                                                   @"avatar" : @"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
    //                                                   @"content" : @"I don't kile this size of the colthes",
    //                                                   @"product":@{},
    //                                                   @"type":@"content",
    //                                                   @"date_added":@1467512353,
    //
    //                                                   @"gender":@0,
    //                                                   @"news_id":@0,
    //                                                   @"newstype":@"custom"
    //                                                   },
    //                                               @{
    //                                                   @"author":@"Sam Chen",
    //                                                   @"avatar" : @"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
    //                                                   @"content" : @"welcome to home",
    //                                                   @"product":@{},
    //                                                   @"type":@"content",
    //                                                   @"date_added":@1467512353,
    //
    //                                                   @"gender":@2,
    //                                                   @"news_id":@1,
    //                                                   @"newstype":@"seller"
    //                                                   },
    //
    //                                               @{
    //                                                   @"author":@"Sam Chen",
    //                                                   @"avatar" : @"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
    //                                                   @"content" : @"",
    //                                                   @"product":@{
    //                                                           @"product_id" : @678,
    //                                                           @"thumb" :@"http://www.waimaoshoudan.com/image/cache/catalog/cat/8053672561395_shad_qt-500x500.jpg",
    //                                                           @"special" : @"CN¥398",
    //                                                           @"price" : @"CN¥1,987",
    //                                                           @"title" : @"Business Dress Suits with pants blazer Business Dress Suits with pants blazer",
    //                                                           },
    //                                                   @"type":@"product",
    //                                                   @"date_added":@1467512353,
    //
    //                                                   @"gender":@0,
    //                                                   @"news_id":@2,
    //                                                   @"newstype":@""
    //                                                   },
    //                                               @{
    //                                                   @"author":@"Sam Chen",
    //                                                   @"avatar" : @"http://www.waimaoshoudan.com/im",
    //                                                   @"content" : @"I don't kile ",
    //                                                   @"product":@{},
    //                                                   @"type":@"content",
    //                                                   @"date_added":@1467701421,
    //
    //                                                   @"gender":@0,
    //                                                   @"news_id":@3,
    //                                                   @"newstype":@"custom"
    //                                                   },
    //                                               ]
    //
    //                                       }
    //                               };
    //
    ////         NSLog(@"**************dicArry is %@", dict);
    //
    //        NSNumber *status = [dict objectForKey:@"status"];
    //        NSNumber *s= [NSNumber numberWithInt:1];
    //        if ([status isEqualToNumber:s]){
    //            NSArray *sDic = [dict objectForKey:@"data"];
    //
    //            //第一次读消息时
    //            if ([type isEqualToString:@"new"] && ([newsId intValue] == 0)){
    //                [self.supportArr removeAllObjects];
    //                self.oldTime = @"0";
    //            }
    //
    //
    //            if (![sDic isKindOfClass:[NSNull class]]){
    //
    //
    //                CustomerSupportModel *customerData= [CustomerSupportModel mj_objectWithKeyValues:sDic];
    //                self.supportNum = customerData.num;
    //                self.systTitle = customerData.title;
    //                self.dateTitle = customerData.date_added;
    //
    //                if ([type isEqualToString:@"new"]){
    //                    for (int i = 0; i < customerData.support.count; i++){
    //                        [self.supportArr addObject:customerData.support[i]];
    //                    }
    //                }else if ([type isEqualToString:@"old"]){
    //
    //                    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
    //                    for (int i = 0; i < customerData.support.count; i++){
    //                        [tmpArr addObject:customerData.support[i]];
    //                    }
    //                    for (int j = 0; j < self.supportArr.count; j++){
    //                        [tmpArr addObject:self.supportArr[j]];
    //                    }
    //                    [self.supportArr removeAllObjects];
    //                    for (int s = 0; s < tmpArr.count; s++){
    //                        [self.supportArr addObject:tmpArr[s]];
    //                    }
    //                }
    //                NSLog(@"**self.supportArr is %@\n count is %lu", self.supportArr, (unsigned long)self.supportArr.count);
    //
    //                [self.chatTable reloadData];
    //            }
    //
    //        }
    //        [MBPromptView hideLoading];
    
    
    
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
    [parameters setObject:type forKey:@"type"];
    
    NSString *currencyType=[defaults objectForKey:@"CurrentCurrency"];//设置货币类型
    if (currencyType.length == 0 || currencyType == nil){
        currencyType = [defaults objectForKey:@"CurrentCountry"];//系统货币类型
    }
    [parameters setObject:currencyType forKey:@"currency_type"];//商品货币类型
    
    [parameters setObject:[MainViewManager currentDateString] forKey:@"time"];
    [parameters setObject:newsId forKey:@"news_id"];
    [parameters setObject:@"newsupport" forKey:@"req"];
    
    //    NSLog(@"postParameter is %@", parameters );
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
        
        [MBPromptView hideLoading];
//        NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            NSArray *sDic = [responseBody objectForKey:@"data"];
            
            //第一次读消息时
            if ([type isEqualToString:@"new"] && ([newsId intValue] == 0)){
                [self.supportArr removeAllObjects];
                self.oldTime = @"0";
                if (!self.supportTimer) {
                    self.supportTimer = [NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(supportTimerAction) userInfo:nil repeats:YES];
                    [[NSRunLoop mainRunLoop] addTimer:self.supportTimer forMode:NSRunLoopCommonModes];
                }
            }
            
            
            if (![sDic isKindOfClass:[NSNull class]]){
                CustomerSupportModel *customerData= [CustomerSupportModel mj_objectWithKeyValues:sDic];
                self.supportNum = customerData.num;
                self.systTitle = customerData.title;
                self.dateTitle = customerData.date_added;
                
                if ([type isEqualToString:@"new"]){
                    for (int i = 0; i < customerData.support.count; i++){
                        [self.supportArr addObject:customerData.support[i]];
                    }
                    if (customerData.support.count>0) {
                        [self.chatTable reloadData];
                        //手动发送
                        if (self.isSend) {
                            if (self.chatTable.contentSize.height>self.chatTable.bounds.size.height) {
                                [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:YES];
                            }
                            self.isSend = NO;
                        }
                        //第一次进入聊天
                        if ([newsId intValue] == 0) {
                            if (self.chatTable.contentSize.height>self.chatTable.bounds.size.height) {
                                [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:NO];
                            }
                        }else{
                            //自动获取新消息
                            if (self.chatTable.contentOffset.y<self.chatTable.contentSize.height-2*self.chatTable.bounds.size.height) {
                                self.messageBtn.hidden = NO;
                            }else{
                                [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:YES];
                            }
                        }

                        
                    }
                    if ([newsId intValue] == 0) {
                        if([self.supportNum integerValue]>0){
                            self.messageL.text = [NSString stringWithFormat:ZDLocalizedString(@"YouHaveUnredMessage", nil),[self.supportNum integerValue]];
                            self.messageL.hidden = NO;
                        }

                        [self.chatTable reloadData];
                    }
                
                }else if ([type isEqualToString:@"old"]){
                    NSMutableArray *tmpArr = [[NSMutableArray alloc] init];
                    for (int i = 0; i < customerData.support.count; i++){
                        [tmpArr addObject:customerData.support[i]];
                    }
                    for (int j = 0; j < self.supportArr.count; j++){
                        [tmpArr addObject:self.supportArr[j]];
                    }
                    [self.supportArr removeAllObjects];
                    for (int s = 0; s < tmpArr.count; s++){
                        [self.supportArr addObject:tmpArr[s]];
                    }
                    [self.chatTable reloadData];
                }
                
            }
            
            
        }else{
            if (self.isSend) {
                NSString *message = [responseBody objectForKey:@"message"];
                if (message != nil){
                    [ZXZPromptView failWithDetail:message];
                }
                self.isSend = NO;
            }
            self.isSysMessage = NO;
        }
        
        if (self.isActivityShow){
            //菊花结束
            [_activity stopAnimating];
            UIView * emptyView = [[UIView alloc] initWithFrame:CGRectZero];
            _chatTable.tableHeaderView=emptyView;

            self.isActivityShow = NO;
            [self.supportTimer setFireDate:[NSDate date]];
        }
        
    } failureBlock:^(NSString *error){
        
        [MBPromptView hideLoading];
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
        if (self.isActivityShow){
            //菊花结束
            [_activity stopAnimating];
            UIView * emptyView = [[UIView alloc] initWithFrame:CGRectZero];
            _chatTable.tableHeaderView=emptyView;
            self.isActivityShow = NO;
            [self.supportTimer setFireDate:[NSDate date]];
            
        }
        
    }];

}

//发送消息
- (void)postSendSupport:(NSString *)type newsId:(NSString *)newsId content:(NSString *)content{
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
    [parameters setObject:type forKey:@"type"];
    
    NSString *currencyType=[defaults objectForKey:@"CurrentCurrency"];//设置货币类型
    if (currencyType.length == 0 || currencyType == nil){
        currencyType = [defaults objectForKey:@"CurrentCountry"];//系统货币类型
    }
    [parameters setObject:currencyType forKey:@"currency_type"];//商品货币类型
    
    [parameters setObject:[MainViewManager currentDateString] forKey:@"time"];
    [parameters setObject:newsId forKey:@"news_id"];
    [parameters setObject:content forKey:@"content"];
    //清空
    self.textTF.text=@"";
    
    [parameters setObject:@"sendsupport" forKey:@"req"];
    
//        NSLog(@"postParameter is %@", parameters );
    [[NetworkSingleton sharedManager] postCWDataResult:parameters url:kMAINHANDLER_URL successBlock:^(id responseBody){
        
        [MBPromptView hideLoading];
//                NSLog(@"获取数据成功 is %@", responseBody);
        
        NSNumber *status = [responseBody objectForKey:@"status"];
        NSNumber *s= [NSNumber numberWithInt:1];
        if ([status isEqualToNumber:s]){
            NSArray *sDic = [responseBody objectForKey:@"data"];
            if (![sDic isKindOfClass:[NSNull class]]){
                CustomerSupportModel *customerData= [CustomerSupportModel mj_objectWithKeyValues:sDic];
                for (int i = 0; i < customerData.support.count; i++){
                    [self.supportArr addObject:customerData.support[i]];
                }
                
                [self.chatTable reloadData];
                if (self.chatTable.contentSize.height>self.chatTable.bounds.size.height) {
                    [self.chatTable setContentOffset:CGPointMake(0, self.chatTable.contentSize.height -self.chatTable.bounds.size.height) animated:YES];
                }
            }
            
        }else{
            NSString *message = [responseBody objectForKey:@"message"];
            if (message != nil){
                [ZXZPromptView failWithDetail:message];
            }
        }
        
    } failureBlock:^(NSString *error){
        
        [MBPromptView hideLoading];
        [ZXZPromptView failWithTitle:ZDLocalizedString(@"TxNE", nil) detail:ZDLocalizedString(@"TxNCF", nil)];
        
    }];
    
}


@end
