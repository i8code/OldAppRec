//
//  PageSet.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageSet : NSObject

@property NSInteger setNumber;
@property NSInteger tagPageCount;
@property NSInteger totalTagPages;
@property NSInteger totalSets;
@property (nonatomic, strong) NSArray* tagPages;

+(PageSet*)fromJSON:(NSDictionary*)dictionary;

@end
