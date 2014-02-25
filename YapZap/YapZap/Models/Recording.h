//
//  Recording.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording : NSObject

/*
 username : {
 type: String,
 trim: true
 },
 parent_name :{
 type:String
 },
 parent_type :{
 type:String, default: "TAG"
 },
 children:{
 type:Array, default:[]
 },
 children_length :{
 type: Number, default:0
 },
 mood :{
 type: Number, default:0
 },
 intensity :{
 type: Number, default:0
 },
 likes : {
 type:Number, default:0
 },
 popularity :{
 type:Number, default:1
 },
 audio_url:{
 type:String,
 default: "jasontest"
 },
 audio_hash:{
 type:String
 },
 waveform_data: [Number],
 created_date: {
 type:Date, default:Date.now
 },
 last_update: {
 type:Date, default:Date.now
 }*/

@property (nonatomic, strong) NSString* _id;
@property (nonatomic, strong) NSString* username;
@property (nonatomic, strong) NSString* parentName;
@property (nonatomic, strong) NSString* parentType;
@property (nonatomic, strong) NSArray* children;
@property NSInteger childrenLength;
@property (nonatomic, strong) NSString* audioUrl;
@property (nonatomic, strong) NSString* audioHash;
@property (nonatomic, strong) NSArray* waveformData;

@property CGFloat mood;
@property CGFloat intensity;

@property NSInteger likes;
@property NSInteger popularity;

@property (nonatomic, strong) NSDate* createdDate;
@property (nonatomic, strong) NSDate* lastUpdate;


+(Recording*)fromJSON:(NSDictionary*)dictionary;

@end
