//
//  CoreDataManager.m
//  YapZap
//
//  Created by Jason R Boggess on 3/5/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "CoreDataManager.h"
#import "LikeCoreData.h"
#import "RecordingCoreData.h"
#import <CoreData/CoreData.h>

@interface CoreDataManager()

@end

@implementation CoreDataManager

static UIManagedDocument* _database = nil;

+(void) useDocument
{
    if (![[NSFileManager defaultManager] fileExistsAtPath:[_database.fileURL path]])
    {
        [_database saveToURL:_database.fileURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success)
         {
             if (success)
             {
                 NSLog(@"Core Data database created");
                 //[CoreDataWrapper addFakeDataforDebug];
                 
             }
             else
                 NSLog(@"Error creating database");
         }];
    }
    else if (_database.documentState == UIDocumentStateClosed)
    {
        [_database openWithCompletionHandler:^(BOOL success)
         {
             if (success)
                 NSLog(@"Database opened");
             else
                 NSLog(@"Error opening database");
         } ];
    }
    else if (_database.documentState == UIDocumentStateNormal)
    {
        //We good. :P
    }
    
}

+(UIManagedDocument*) database
{
    if (!_database)
    {
        //Create the database
        NSURL* url  =   [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
        url = [url URLByAppendingPathComponent:@"YapZapDatabase"];
        _database = [[UIManagedDocument alloc] initWithFileURL:url];
        [CoreDataManager useDocument];
    }
    
    return _database;
}

+(LikeCoreData*)getLikeByRecordingId:(NSString*)recordingId{
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"LikeCoreData" inManagedObjectContext:self.database.managedObjectContext];
    [request setEntity:entity];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"recording_id=%@", recordingId];
    [request setPredicate:predicate];
    
    NSError *error;
    NSArray *fetchResults = [self.database.managedObjectContext executeFetchRequest:request error:&error];
    
    if (!fetchResults || fetchResults.count==0){
        return nil;
    }
    return [fetchResults objectAtIndex:0];
}

+(void)like:(NSString*)recordingId{
    if (![self liked:recordingId]){
        LikeCoreData* like = [NSEntityDescription insertNewObjectForEntityForName:@"LikeCoreData" inManagedObjectContext:[self database].managedObjectContext];
        like.recording_id = recordingId;
        
        [self.database.managedObjectContext save:nil];
    }
}

+(void)unlike:(NSString*)recordingId{
    LikeCoreData* like = [self getLikeByRecordingId:recordingId];
    if (like){
        [self.database.managedObjectContext deleteObject:like];
        [self.database.managedObjectContext save:nil];
    }
}
+(BOOL)liked:(NSString*)recordingId{
    return !![self getLikeByRecordingId:recordingId];
}

@end
