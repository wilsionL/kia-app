//
//  SummaryModel.h
//  kia-app
//
//  Created by jieyeh on 14/10/31.
//  Copyright (c) 2014年 jieyeh. All rights reserved.
//

#import "JSONModel.h"

@interface SummaryModel : JSONModel
@property (nonatomic, strong) NSNumber<Optional>* come;
@property (nonatomic, strong) NSNumber<Optional>* back;
@property (nonatomic, strong) NSNumber<Optional>* noassign;
@property (nonatomic, strong) NSNumber<Optional>* cluecount;
@property (nonatomic, strong) NSNumber<Optional>* nofollowup;
@property (nonatomic, strong) NSNumber<Optional>* infollowup;
@property (nonatomic, strong) NSNumber<Optional>* timeout;
@property (nonatomic, strong) NSNumber<Optional>* timeoutremind;
@property (nonatomic, strong) NSNumber<Optional>* audit;
@end
