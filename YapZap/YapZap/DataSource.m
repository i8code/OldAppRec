//
//  DataSource.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "DataSource.h"
#import "SampleData.h"
#import "PageSet.h"

@interface DataSource()

@end

@implementation DataSource


static NSArray* _pages;

+(NSArray*)pages{
    if (_pages==nil){
        NSData *jsonData = [[SampleData getJSON] dataUsingEncoding:NSUTF8StringEncoding];
        NSArray* pagesJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
        
        NSMutableArray* array = [[NSMutableArray alloc] init];
        for (NSDictionary* page in pagesJson){
            [array addObject:[PageSet fromJSON:page]];
        }
        _pages = array;
    }
    
    return _pages;
}

+(PageSet*)getSet:(NSInteger)setNum{
    
    if ([DataSource pages]==nil || setNum<0 || setNum>=[DataSource pages].count){
        return nil;
    }
    
    return [DataSource pages][setNum];
}

@end
