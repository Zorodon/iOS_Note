//
//  GoodsListCell.m
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import "GoodsListCell.h"
#import "CustomerSupportModel.h"

@interface GoodsListCell()

@property(nonatomic,strong)UIImageView*icon;

@property(nonatomic,strong)UILabel*content_lb;

@property(nonatomic,strong)UILabel*price_lb;

@property(nonatomic,strong)UILabel*money_lb;

//@property(nonatomic,strong)UILabel*time_lb;



@end

@implementation GoodsListCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingUpSubViews];
    }
    return self;
}

-(void)settingUpSubViews{
    self.contentView.backgroundColor=[UIColor whiteColor];
    
//    //时间
//    _time_lb=[[UILabel alloc]initWithFrame:CGRectMake(0, 20, kScreenWidth, 15)];
////    _time_lb.text=@"2016 8 8";
//    _time_lb.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
//    _time_lb.font=[UIFont boldSystemFontOfSize:14];
//    _time_lb.textAlignment=NSTextAlignmentCenter;
//    [self.contentView addSubview:_time_lb];
////    [_time_lb mas_makeConstraints:^(MASConstraintMaker *make) {
////        make.centerX.equalTo(self.contentView.mas_centerX);
////        make.top.equalTo(self.contentView.mas_top).offset(20);
////    }];

    UIView*v=[[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor groupTableViewBackgroundColor];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(10);
        make.left.equalTo(self.contentView.mas_left).offset(40);
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    //小图标
    _icon=[[UIImageView alloc]initWithFrame:CGRectZero];
//    _icon.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_icon];
    [_icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_top).offset(10);
        make.left.equalTo(v.mas_left).offset(10);
        make.bottom.equalTo(v.mas_bottom).offset(-10);
        make.width.equalTo(@64);
    }];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    
    //小标题
    _content_lb=[[UILabel alloc]initWithFrame:CGRectZero];
//    _content_lb.text=@"2016阿萨德加拉斯的骄傲网切";
    _content_lb.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    _content_lb.font=[UIFont boldSystemFontOfSize:14];
    _content_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_content_lb];
    [_content_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_top).offset(10);
        make.right.equalTo(v.mas_right).offset(-10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    //价位
    _price_lb=[[UILabel alloc]initWithFrame:CGRectZero];
//    _price_lb.text=@"京东价：";
    _price_lb.textColor=[UIColor colorWithRed:128/255 green:128/255 blue:128/255 alpha:1];
    _price_lb.font=[UIFont boldSystemFontOfSize:15];
    _price_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_price_lb];
    [_price_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_content_lb.mas_bottom).offset(10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    //价钱
    _money_lb=[[UILabel alloc]initWithFrame:CGRectZero];
//    _money_lb.text=@"$520";
    _money_lb.font=[UIFont systemFontOfSize:12];
    _money_lb.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
    _money_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_money_lb];
    [_money_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price_lb.mas_centerY);
        make.right.equalTo(v.mas_right).offset(-10);
        make.left.equalTo(_price_lb.mas_right).offset(5);
    }];
    
    _topline=[[UIImageView alloc]initWithFrame:CGRectZero];
    _topline.image=[UIImage imageNamed:@"contactline"];
    [self.contentView addSubview:_topline];
    [_topline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(_icon.mas_centerY);
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    _bottomline=[[UIImageView alloc]initWithFrame:CGRectZero];
    _bottomline.image=[UIImage imageNamed:@"contactline"];
    [self.contentView addSubview:_bottomline];
    [_bottomline mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView.mas_bottom);
        make.top.equalTo(_icon.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).offset(20);
    }];
    
    _area=[[UIImageView alloc]initWithFrame:CGRectZero];
    _area.image=[UIImage imageNamed:@"round2"];
    [self.contentView addSubview:_area];
    [_area mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(_bottomline.mas_centerX);
        make.centerY.equalTo(_icon.mas_centerY);
        make.height.equalTo(@20);
        make.width.equalTo(@20);
    }];
}

-(void)settingLabelValue:(NSArray*)productarr andIndexpath:(NSInteger)indexPath{
    if (indexPath==0) {
        //_area.image=[UIImage imageNamed:@"round"];
        _topline.hidden=YES;
    }
    if (indexPath==productarr.count-1){
        _bottomline.hidden=YES;
    }
    
    productModel *productData = [productModel mj_objectWithKeyValues:productarr[indexPath]];
    
    //_time_lb.text = [MainViewManager showDateMode:productData.date_added type:@"date"];
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:productData.thumb] placeholderImage:[UIImage imageNamed:@"refresh1"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            _icon.image = [UIImage imageNamed:@"photofail"];
        }else {
            //将imageView的背景颜色设置为图片左边中间一个像素点的颜色
            _icon.backgroundColor = [MainViewManager getImageEdgeColor:image];
        }
    }];
    
    _content_lb.text=productData.title;
    
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
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
