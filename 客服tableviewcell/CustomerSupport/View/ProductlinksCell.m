//
//  ProductlinksCell.m
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import "ProductlinksCell.h"

@interface ProductlinksCell()

@property(nonatomic,strong)UIImageView*icon;

@property(nonatomic,strong)UILabel*content_lb;

@property(nonatomic,strong)UILabel*price_lb;

@property(nonatomic,strong)UILabel*money_lb;   //钱数

@property(nonatomic,strong)UIImageView*avatars_left;

@property(nonatomic,strong)UIImageView*avatars_right;


@end

@implementation ProductlinksCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingUpSubViews];
    }
    return self;
}

-(void)settingUpSubViews {
    self.contentView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    //人物头像 左边
    _avatars_left=[[UIImageView alloc]initWithFrame:CGRectZero];
    _avatars_left.layer.cornerRadius=20;
    _avatars_left.layer.masksToBounds=YES;
    //_avatars_left.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_avatars_left];
    _avatars_left.contentMode = UIViewContentModeScaleAspectFit;
    [_avatars_left mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];
    
    //人物头像  右边
    _avatars_right=[[UIImageView alloc]initWithFrame:CGRectZero];
    _avatars_right.layer.cornerRadius=20;
    _avatars_right.layer.masksToBounds=YES;
    //_avatars_right.backgroundColor=[UIColor redColor];
    [self.contentView addSubview:_avatars_right];
    _avatars_right.contentMode = UIViewContentModeScaleAspectFit;
    [_avatars_right mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.height.equalTo(@40);
        make.width.equalTo(@40);
    }];

    
    UIView*v=[[UIView alloc]initWithFrame:CGRectZero];
    v.backgroundColor=[UIColor whiteColor];
    [self.contentView addSubview:v];
    [v mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView.mas_top).offset(45);
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    
    //产品图片
    _icon=[[UIImageView alloc]initWithFrame:CGRectZero];
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
    
    _content_lb.textColor=[UIColor colorWithRed:51/255 green:51/255 blue:51/255 alpha:1];
    _content_lb.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:14];
    _content_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_content_lb];
    [_content_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(v.mas_top).offset(20);
        make.right.equalTo(v.mas_right).offset(-10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    //价位
    _price_lb=[[UILabel alloc]initWithFrame:CGRectZero];
//    _price_lb.text=@"京东价：";
    _price_lb.textColor=[UIColor colorWithRed:128/255 green:128/255 blue:128/255 alpha:1];
    _price_lb.font=[UIFont fontWithName:kDefaultAppFontBoldTypeName  size:13];
    _price_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_price_lb];
    [_price_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_content_lb.mas_bottom).offset(8);
        //make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.left.equalTo(_icon.mas_right).offset(10);
    }];
    //价钱
    _money_lb=[[UILabel alloc]initWithFrame:CGRectZero];
//    _money_lb.text=@"$520";
    _money_lb.font=[UIFont fontWithName:kDefaultAppFontTypeName  size:11];
    _money_lb.textColor=[UIColor colorWithRed:128/255.0 green:128/255.0 blue:128/255.0 alpha:1];
    _money_lb.textAlignment=NSTextAlignmentLeft;
    [self.contentView addSubview:_money_lb];
    [_money_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(_price_lb.mas_centerY);
        make.right.equalTo(v.mas_right).offset(-10);
        make.left.equalTo(_price_lb.mas_right).offset(5);
    }];
}

- (void) setProductData:(productModel *)productData newsType: (NSString *)newstype andImage:(NSString*)imgUrl Gender:(NSString *)gender{
  
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
    
    //头像
    if ([newstype isEqualToString:@"custom"]){
        _avatars_left.hidden=YES;
      
        NSString *str;
        if ([gender integerValue] == 2){
            str = @"female";
        }else if ([gender integerValue] == 1){
            str = @"male";
        }else{
            str = @"gender";
        }
         _avatars_right.hidden=NO;
        [_avatars_right sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:str]];
    }else {
        _avatars_right.hidden=YES;
        [_avatars_left sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"suphead"]];
        _avatars_left.hidden=NO;
    }
    

    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
