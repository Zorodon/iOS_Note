//
//  UserMessageTableViewCell.h
//  ChatUI
//
//  Created by YKJ3 on 16/6/30.
//  Copyright © 2016年 YKJ3. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserMessageTableViewCell : UITableViewCell

-(void)setUserMessageLabelValue:(NSString*)text andImage:(NSString*)imgUrl gender:(NSString *)gender time:(NSString *)time;

@end
