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
#import "Tag.h"
#import "Recording.h"

@interface DataSource()

@end

@implementation DataSource


static NSArray* _pages;
static NSArray* _tags;

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

+(NSArray*)getTagNames{
    
    [NSThread sleepForTimeInterval:2];
    
    NSData *jsonData = [[SampleData getTagNameJson] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray* tagNamesJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSString* tagName in tagNamesJson){
        [array addObject:tagName];
    }
    
    return array;
}

+(NSArray*)getPopularTags{
    
    [NSThread sleepForTimeInterval:2];
    
    NSData *jsonData = [[SampleData getPopularTags] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray* tagsJson = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* tagDic in tagsJson){
        [array addObject:[Tag fromJSON:tagDic]];
    }
    _tags = array;
    return array;
}

+(Tag*)getNextPopularTag{
    static int currentTag = 0;
    if(_tags==nil){
       [self getPopularTags];
    }
    
    return [_tags objectAtIndex:currentTag++];
}
+(NSArray*)getRecordingsForTagName:(NSString*)tagName{
    
    [NSThread sleepForTimeInterval:2];
    
    NSData *jsonData = [[SampleData getRecordingsForTagName:tagName] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray* recordingsDic = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSMutableArray* array = [[NSMutableArray alloc] init];
    for (NSDictionary* recDic in recordingsDic){
        [array addObject:[Recording fromJSON:recDic]];
    }
    
    return array;
}

@end
