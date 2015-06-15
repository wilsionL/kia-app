//
//  ClueMasterInfo.h
//  kia-app
//
//  Created by jieyeh on 14/11/1.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface ClueMasterInfo : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString<Optional>* comedate;
@property (nonatomic, strong) NSString<Optional>* cartype;
@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, strong) NSString<Optional>* mobile;
@property (nonatomic, strong) NSString <Optional>* phone;
@property (nonatomic, strong) NSString<Optional>* salesid;
@property (nonatomic, strong) NSString<Optional> *salesname;
@property (nonatomic, strong) NSNumber<Optional>* isChecked;
@end

@protocol ClueMasterInfo <NSObject>

@end
// 未分配线索
@interface ClueAssignInfo : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* comedate;
@property (nonatomic, strong) NSString* cartype;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSNumber<Optional>* isChecked;
@end

@protocol ClueAssignInfo <NSObject>

@end

// 未分配线索
@interface CluesAduit : JSONModel
@property (nonatomic, strong) NSString<Optional>* identity;
@property (nonatomic, strong) NSString<Optional>* cluesNo;
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic, strong) NSString<Optional>* phone;
@property (nonatomic, strong) NSString<Optional>* updatetime;
@property (nonatomic, strong) NSString<Optional>* aduitdate;
@property (nonatomic, strong) NSString<Optional>* advisorname;
@property (nonatomic, strong) NSString<Optional>* clueslevelid;
@property (nonatomic, strong) NSString<Optional>* keycode;
@property (nonatomic, strong) NSString<Optional>* remark;
@property (nonatomic, strong) NSString<Optional>* salesname;
@property (nonatomic, strong) NSString<Optional>* salesid;
@property (nonatomic, strong) NSNumber<Optional>* isChecked;
@property (nonatomic, strong) NSString<Optional>* cartype;
@end
@protocol CluesAduit <NSObject>

@end
@interface CluesAduitList : JSONModel
@property (nonatomic, strong) NSArray<CluesAduit, Optional>* CluesAduit;
@end

@interface ClueHistory : JSONModel
@property (nonatomic, strong) NSString* optdate;
@property (nonatomic, strong) NSString* optuser;
@property (nonatomic, strong) NSString* followersult;
@end

@protocol ClueHistory <NSObject>

@end
@interface ClueDetailInfo : JSONModel
@property (nonatomic, strong) NSString* identity;
@property (nonatomic, strong) NSString<Optional>* name;
@property (nonatomic, strong) NSString<Optional>* mobile;
@property (nonatomic, strong) NSString<Optional>* cartype;
@property (nonatomic, strong) NSString<Optional>* level;
@property (nonatomic, strong) NSString<Optional>* source;
@property (nonatomic, strong) NSString<Optional>* status;
@property (nonatomic, strong) NSString<Optional>* carseriesname;
@property (nonatomic, strong) NSString<Optional>* carmodelname;
@property (nonatomic, strong) NSString<Optional>* carmodelid;
@property (nonatomic, strong) NSString<Optional>* carseriesid;
@property (nonatomic, strong) NSArray<ClueHistory, Optional>* history;
@end
@interface NewClueInfo : JSONModel
@property (nonatomic, strong) NSString* name;
@property (nonatomic, strong) NSString* mobile;
@property (nonatomic, strong) NSString* cars;
@property (nonatomic, strong) NSString* models;
@property (nonatomic, strong) NSString* source;

@property (nonatomic, strong) NSString* specificsource;

@property (nonatomic, strong) NSString* level;

@property (nonatomic, strong) NSString* consultingid;

@property (nonatomic, strong) NSString* sex;
@property (nonatomic, strong) NSString* plandata;
@property (nonatomic, strong) NSString* province;
@property (nonatomic, strong) NSString* city;
@end