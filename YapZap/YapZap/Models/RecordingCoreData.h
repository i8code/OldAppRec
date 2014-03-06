//
//  RecordingCoreData.h
//  YapZap
//
//  Created by Jason R Boggess on 3/5/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface RecordingCoreData : NSManagedObject

@property (nonatomic, retain) NSString * uid;
@property (nonatomic, retain) NSNumber * percent_played;

@end
