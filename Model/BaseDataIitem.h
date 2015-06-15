//
//  BaseDataIitem.h
//  kia-app
//
//  Created by jieyeh on 14/11/4.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface BaseDataItem : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString* keycode;
@property (nonatomic, strong) NSString* ramark;
@end
@protocol BaseDataItem <NSObject>

@end

@interface KeyValue : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString* name;
@end
@protocol KeyValue <NSObject>

@end

@interface ChannelInfo : JSONModel
@property (nonatomic, strong) NSString* channelID;
@property (nonatomic, strong) NSString* name;
@end
@protocol ChannelInfo <NSObject>

@end
