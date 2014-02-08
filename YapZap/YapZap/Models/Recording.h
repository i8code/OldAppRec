//
//  Recording.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Recording : NSObject

@property (nonatomic, strong) NSString* firstName;
@property (nonatomic, strong) NSString* waveformUrl;
@property (nonatomic, strong) NSString* audioUrl;

@property NSInteger likes;
@property NSInteger dislikes;


@end
