//
//  ChannelViewController.h
//  kia-app
//
//  Created by jieyeh on 14/11/5.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ChannelInfo;
@protocol ChannelViewControllerDelegate <NSObject>
-(void) SelectedChannel:(ChannelInfo*) sub andThird:(ChannelInfo*) third;
@end

@interface ChannelViewController : UIViewController
@property(nonatomic, strong) ChannelInfo* category;
@property (nonatomic, strong) ChannelInfo* subCategoryValue;
@property (nonatomic, strong) ChannelInfo* thirdCategoryValue;
@property (nonatomic, assign)id<ChannelViewControllerDelegate> delegate;
@end
