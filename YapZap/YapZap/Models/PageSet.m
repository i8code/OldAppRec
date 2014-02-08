//
//  PageSet.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "PageSet.h"
#import "TagPage.h"

@implementation PageSet

+(PageSet*)fromJSON:(NSDictionary*)dictionary{
    
    PageSet* set = [[PageSet alloc] init];
    
    set.setNumber       = [[dictionary objectForKey:@"setNumber"] integerValue];
    set.tagPageCount    = [[dictionary objectForKey:@"tagPageCount"] integerValue];
    set.totalTagPages   = [[dictionary objectForKey:@"totalTagPages"] integerValue];
    set.totalSets       = [[dictionary objectForKey:@"totalSets"] integerValue];
    
    NSArray* pageDictionaries = [dictionary objectForKey:@"tagPages"];
    
    NSMutableArray* pageArray =[[NSMutableArray alloc] init];
    
    for (NSDictionary* dictionary in pageDictionaries){
        [pageArray addObject:[TagPage fromJSON:dictionary]];
    }
    
    set.tagPages = pageArray;
    
    return set;
}

@end
