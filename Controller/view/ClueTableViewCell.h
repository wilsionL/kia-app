//
//  ClueTableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/2.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClueTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* lbName;
@property (nonatomic, weak) IBOutlet UILabel* lbStatus;
@property (nonatomic, weak) IBOutlet UILabel* lbCarType;
@property (nonatomic, weak) IBOutlet UILabel* lbDate;
@end
