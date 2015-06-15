//
//  EditClueTableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/10.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class EditClueTableViewCell;
@protocol EditClueTableViewCellDelegate <NSObject>
-(void)SetComeState:(EditClueTableViewCell*) cell andState:(NSString*)state;
@end
@interface EditClueTableViewCell : UITableViewCell
@property (nonatomic, weak) NSString* iscome;
@property (nonatomic, assign) id<EditClueTableViewCellDelegate> delegate;
@end
