//
//  EditClue3TableViewCell.h
//  kia-app
//
//  Created by wewin-mac on 14/12/24.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditClue3TableViewCell;
@protocol EditClue3TableViewCellDelegate <NSObject>
-(void)changeTextView3:(EditClue3TableViewCell*) cell andText:(NSString*)val;
@end
@interface EditClue3TableViewCell : UITableViewCell
@property (nonatomic, assign) id<EditClue3TableViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UITextView *vinText;
@property (weak, nonatomic) IBOutlet UILabel *nameText;

@end
