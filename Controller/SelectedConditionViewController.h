//
//  SelectedConditionViewController.h
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "BaseViewController.h"

@protocol SelectedConditionViewControllerDelegate <NSObject>
-(void) SelectedItem:(NSString*)category
        andFieldName:(NSString*) fieldName
          andNavType:(NSString*)navType
          andSubType:(NSString*)subType
           andValue1:(id) val1
           andValue2:(id)val2
           andValue3:(id)val3;
@end

@interface SelectedConditionViewController : BaseViewController
@property (nonatomic, strong) NSString* category;
@property (nonatomic, strong) NSString* fieldName;
@property (nonatomic, strong) NSString* type;
@property (nonatomic, strong) NSString* subType;
@property (nonatomic, strong) NSString* value;
@property (nonatomic, strong) id objValue;
@property (nonatomic, assign) id<SelectedConditionViewControllerDelegate> delegate;
@end
