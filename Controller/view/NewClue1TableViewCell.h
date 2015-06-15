//
//  NewClue1TableViewCell.h
//  kia-app
//
//  Created by jieyeh on 14/11/3.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NewClue1TableViewCell;
@protocol NewClue1TableViewCellDelegate <NSObject>
-(void)valueChange:(NewClue1TableViewCell*)cell
      andFieldName:(NSString*)fieldName
       andNewValue:(NSString*)value;
@end

@interface NewClue1TableViewCell : UITableViewCell
@property (nonatomic, strong) NSString* fieldName;
@property (nonatomic, weak) IBOutlet UILabel* lbName;
@property (nonatomic, weak) IBOutlet UITextField* lbValue;
@property (nonatomic, assign) NSInteger maxLength;
@property (nonatomic, weak) NSMutableDictionary* valDict;
@property (nonatomic, assign) id<NewClue1TableViewCellDelegate> delegate;
@end
