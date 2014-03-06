//
//  Notification.h
//  YapZap
//
//  Created by Jason R Boggess on 3/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Notification : NSObject
/*
 username_for : {
 type: String,
 trim: true
 },
 username_by : {
 type: String,
 trim: true
 },
 tag_name:{
 type:String
 },
 recording_id :{
 type:String
 },
 created_date: {
 type:Date, default:Date.now
 },
 type:{
 type:String
 }
 */

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString* usernameFor;
@property (nonatomic, strong) NSString* usernameBy;
@property (nonatomic, strong) NSString* tagName;
@property (nonatomic, strong) NSString* recordingId;
@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSString* type;
@property CGFloat mood;
@property CGFloat intensity;

+(Notification*)fromJSON:(NSDictionary*)json;
@end
