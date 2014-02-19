//
//  Tag.h
//  YapZap
//
//  Created by Jason R Boggess on 2/17/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>


/*
 {
 name : {
 type: String,
 trim: true
 },
 popularity :{
 type:Number, default:0
 },
 children :{
 type: Number, default:0
 },
 mood :{
 type: Number, default:0
 },
 intensity :{
 type: Number, default:0
 },
 created_date: {
 type:Date, default:Date.now
 },
 last_update: {
 type:Date, default:Date.now
 }
 }
 */
@interface Tag : NSObject

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString* name;
@property double popularity;
@property int children;
@property double mood;
@property double intensity;
@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSDate* lastUpdate;

+(Tag*)fromJSON:(NSDictionary*)jsonDictionary;

@end
