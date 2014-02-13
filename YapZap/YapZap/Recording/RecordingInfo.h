//
//  RecordingInfo.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RecordingInfo : NSObject

@property(nonatomic, strong) NSString* url;
@property int length; //data packets
@property float* data;

@end
