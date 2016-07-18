//
//  GoodsListCell.h
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsListCell : UITableViewCell

@property(nonatomic,strong)UIImageView*bottomline;

@property(nonatomic,strong)UIImageView*topline;

@property(nonatomic,strong)UIImageView*area;

-(void)settingLabelValue:(NSArray*)productarr andIndexpath:(NSInteger)indexPath;

@end
