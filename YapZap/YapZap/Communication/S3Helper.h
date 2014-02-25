//
//  S3Helper.h
//  YapZap
//
//  Created by Jason R Boggess on 2/11/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface S3Helper : NSObject

+(NSData*)fileFromS3WithName:(NSString*)name;
+(void)saveToS3:(NSData*)data withName:(NSString*)name;

@end
