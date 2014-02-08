//
//  TagPage.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TagPage : NSObject

@property(nonatomic, strong) NSString* title;
@property(nonatomic, strong) NSString* subTitle;
@property CGFloat mood;
@property CGFloat intensity;

@property (nonatomic, strong) NSArray* recordings;

+(TagPage*)fromJSON:(NSDictionary*)dictionary;

@end
