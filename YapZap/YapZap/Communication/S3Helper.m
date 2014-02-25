//
//  S3Helper.m
//  YapZap
//
//  Created by Jason R Boggess on 2/11/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "S3Helper.h"
#import "Reachability.h"
#import <AWSS3/AWSS3.h>

@implementation S3Helper

#define SECRET_KEY @"kbtyCsxHKC1yJz08/laKNFoFzg+EDdkwFMpZ0TLf"
#define ACCESS_KEY @"AKIAJ7CIUFOP2SG3EQOA"
#define BUCKET_NAME @"yap-zap-audio"

+(BOOL)isWifiAvailable
{
    Reachability *r = [Reachability reachabilityForLocalWiFi];
    return !( [r currentReachabilityStatus] == NotReachable);
}

+(NSData*)fileFromS3WithName:(NSString*)name{
    
    @try {
        AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY withSecretKey:SECRET_KEY];
        S3GetObjectRequest *gor = [[S3GetObjectRequest alloc] initWithKey:name withBucket:BUCKET_NAME];
        
        S3GetObjectResponse* response = [s3 getObject:gor];
        
        return response.body;
    }
    @catch ( AmazonServiceException *exception ) {
        NSLog( @"Upload Failed, Reason: %@", exception );
    }
    
}
+(void)saveToS3:(NSData*)dataToUpload withName:(NSString*)name{
        bool using3G = ![self isWifiAvailable];
        
        @try {
            AmazonS3Client *s3 = [[AmazonS3Client alloc] initWithAccessKey:ACCESS_KEY withSecretKey:SECRET_KEY];
            S3PutObjectRequest *por = [[S3PutObjectRequest alloc] initWithKey:name inBucket:BUCKET_NAME];
            
            // The S3UploadInputStream was deprecated after the release of iOS6.
            S3UploadInputStream *stream = [S3UploadInputStream inputStreamWithData:dataToUpload];
            if ( using3G ) {
                // If connected via 3G "throttle" the stream.
                stream.delay = 0.2; // In seconds
                stream.packetSize = 16; // Number of 1K blocks
            }
            
            por.contentLength = [dataToUpload length];
            por.stream = stream;
            
            [s3 putObject:por];
        }
        @catch ( AmazonServiceException *exception ) {
            NSLog( @"Upload Failed, Reason: %@", exception );
        }
    
}

@end
