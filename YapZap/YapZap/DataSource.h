//
//  DataSource.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>


@class PageSet;

@interface DataSource : NSObject

+(PageSet*)getSet:(NSInteger)setNum;
+(NSArray*)getTagNames;
+(NSArray*)getPopularTags;

@end
