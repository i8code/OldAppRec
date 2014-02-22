//
//  SampleData.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SampleData : NSObject

+(NSString*)getJSON;
+(NSString*)getTagNameJson;
+(NSString*)getPopularTags;
+(NSString*)getRecordingsForTagName:(NSString*)tagName;

@end
