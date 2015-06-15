//
//  ClueDetailTableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/2.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClueDetailTableViewCell : UITableViewCell
@property (nonatomic, weak) IBOutlet UILabel* lbDate;
@property (nonatomic, weak) IBOutlet UILabel* lbUser;
@property (nonatomic, weak) IBOutlet UILabel* lbResult;

@end
