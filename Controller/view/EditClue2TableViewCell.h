//
//  EditClue2TableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditClue2TableViewCell;
@protocol EditClue2TableViewCellDelegate <NSObject>
-(void)changeTextView:(EditClue2TableViewCell*) cell andText:(NSString*)val;
@end
@interface EditClue2TableViewCell : UITableViewCell
@property (nonatomic, assign) id<EditClue2TableViewCellDelegate> delegate;
@property (nonatomic,weak) IBOutlet UITextView* txtView;
@end
