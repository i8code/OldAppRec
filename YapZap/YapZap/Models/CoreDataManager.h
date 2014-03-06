//
//  CoreDataManager.h
//  YapZap
//
//  Created by Jason R Boggess on 3/5/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CoreDataManager : NSObject

+(UIManagedDocument*) database;

+(void)like:(NSString*)recordingId;
+(void)unlike:(NSString*)recordingId;
+(BOOL)liked:(NSString*)recordingId;

@end
