//
//  UserMessageTableViewCell.m
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import "UserMessageTableViewCell.h"

#define SCREEN_H   [UIScreen mainScreen].bounds.size.height
#define SCREEN_W   [UIScreen mainScreen].bounds.size.width
@interface UserMessageTableViewCell()

@property(nonatomic,strong)UIImageView*icon;

@property(nonatomic,strong)UILabel*content_lb;

@property(nonatomic,strong)UILabel*time_lb;

@property(nonatomic,strong)UIImageView*image;
@end

@implementation UserMessageTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self settingUpSubViews];
    }
    return self;
}

-(void)settingUpSubViews{
    self.contentView.backgroundColor=[UIColor groupTableViewBackgroundColor];
    
    _time_lb=[[UILabel alloc]initWithFrame:CGRectZero];
    _time_lb.font=[UIFont fontWithName:kDefaultAppFontTypeName  size:12];
    _time_lb.layer.cornerRadius = 6;
    _time_lb.layer.masksToBounds = YES;
    _time_lb.backgroundColor = [UIColor colorWithWhite:0 alpha:0.1];
    _time_lb.textColor=[UIColor whiteColor];
    _time_lb.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:_time_lb];
//    [_time_lb mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView.mas_top).offset(10);
//        make.centerX.equalTo(self.contentView.mas_centerX);
//        make.height.equalTo(@15);
//    }];
    
    //小图标
    _icon=[[UIImageView alloc]init];
    _icon.layer.cornerRadius=20;
    _icon.layer.masksToBounds=YES;
    [self.contentView addSubview:_icon];
    _icon.contentMode = UIViewContentModeScaleAspectFit;
    
    _image=[[UIImageView alloc]initWithFrame:CGRectZero];
    _image.image=[self newImage:@"contactright"];
    [self.contentView addSubview:_image];

    //小标题
    _content_lb=[[UILabel alloc]initWithFrame:CGRectZero];
    _content_lb.backgroundColor=[UIColor clearColor];
    _content_lb.numberOfLines=0;
    _content_lb.layer.cornerRadius=15;
    _content_lb.font=[UIFont fontWithName:kDefaultAppFontTypeName  size:14];
    _content_lb.textColor=[UIColor darkTextColor];
    [self.contentView addSubview:_content_lb];

}

-(void)setUserMessageLabelValue:(NSString*)text andImage:(NSString*)imgUrl gender:(NSString *)gender time:(NSString *)time{
    CGFloat x= [self getSizeWithAttributedString:[self adjustmentLineSpacing:text]].width;
    CGFloat y= [self getSizeWithAttributedString:[self adjustmentLineSpacing:text]].height;
    
    if (time.length == 0){
        _icon.frame = CGRectMake(kScreenWidth-50, 5, 40, 40);

        _time_lb.hidden=YES;
    }else{
        _icon.frame = CGRectMake(kScreenWidth-50, 35, 40, 40);

        _time_lb.hidden = NO;
        _time_lb.frame = CGRectMake((kScreenWidth-50)/2, 10, 50, 16);
        _time_lb.text = time;
    }
    
    //一行不算行间距
    if(y<20){
        _image.frame=CGRectMake(SCREEN_W-55-(x+25),CGRectGetMinY(_icon.frame)+8 , x+25, y+13);
        _content_lb.text = text;
        _content_lb.frame=CGRectMake(SCREEN_W-CGRectGetWidth(_icon.frame)-30-x,CGRectGetMinY(_icon.frame)+14.5 , x, y);
    }else{
        _image.frame=CGRectMake(SCREEN_W-55-(x+25),CGRectGetMinY(_icon.frame)+8 , x+25, y+16);
        _content_lb.attributedText= [self adjustmentLineSpacing:text];
        _content_lb.frame=CGRectMake(SCREEN_W-CGRectGetWidth(_icon.frame)-30-x,CGRectGetMinY(_icon.frame)+16 , x, y);
    }

    NSString *str;
    if ([gender integerValue] == 2){
        str = @"female";
    }else if ([gender integerValue] == 1){
        str = @"male";
    }else{
        str = @"gender";
    }
    
    [_icon sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:str]];
    
}

// 字体大小
-(CGSize)getSizeWithAttributedString:(NSAttributedString *)text{
    CGRect rect = [text boundingRectWithSize:CGSizeMake(kScreenWidth-100, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil];
    return rect.size;
}
#pragma mark 调整字体 行间距
-(NSMutableAttributedString*)adjustmentLineSpacing:(NSString*)content{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:content];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:3];//调整行间距
    [paragraphStyle setAlignment:NSTextAlignmentLeft];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [content length])];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont fontWithName:kDefaultAppFontTypeName  size:14] range:NSMakeRange(0, [content length])];

    return attributedString;
}
//图片拉伸
-(UIImage*)newImage:(NSString*)name{
    UIImage *image = [UIImage imageNamed:name];
    // 设置端盖的值
    CGFloat top = image.size.height * 0.6;
    CGFloat left = image.size.width * 0.3;
    CGFloat bottom = image.size.height * 0.4;
    CGFloat right = image.size.width * 0.7;
    // 设置端盖的值
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(top, left, bottom, right);
    // 设置拉伸的模式
    UIImageResizingMode mode = UIImageResizingModeStretch;
    // 拉伸图片
    UIImage *newImage = [image resizableImageWithCapInsets:edgeInsets resizingMode:mode];
    
    return newImage;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
