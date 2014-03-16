//
//  MasterPlayerListener.h
//  YapZap
//
//  Created by Jason R Boggess on 3/16/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MasterAudioPlayerCallbackData.h"

@protocol MasterPlayerListener <NSObject>

-(void)audioStateChanged:(MasterAudioPlayerCallbackData*)data;

@end
