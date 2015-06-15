//
//  AssignClueTableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/6.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UICheckbox.h"
@class AssignClueTableViewCell;
@protocol AssignClueTableViewCellDelegate<NSObject>
-(void)SelectSales:(AssignClueTableViewCell*)cell;
-(void)SelectClueInfo:(AssignClueTableViewCell*)cell andIsChecked:(Boolean)checked;
@end
@interface AssignClueTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* lbName;
@property (nonatomic, weak) IBOutlet UILabel* lbStatus;
@property (nonatomic, weak) IBOutlet UILabel* lbCarType;
@property (nonatomic, weak) IBOutlet UILabel* lbUser;
@property (nonatomic, weak) IBOutlet UICheckbox* checkbox;
@property (nonatomic, strong) NSString* salesId;
@property (nonatomic, assign) id<AssignClueTableViewCellDelegate> delegate;
@end
