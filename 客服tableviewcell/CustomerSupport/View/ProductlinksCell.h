//
//  ProductlinksCell.h
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomerSupportModel.h"

@interface ProductlinksCell : UITableViewCell

@property(nonatomic,copy)void(^CellBtnAction)();
- (void) setProductData:(productModel *)productData newsType: (NSString *)newstype andImage:(NSString*)imgUrl Gender:(NSString *)gender;
@end
