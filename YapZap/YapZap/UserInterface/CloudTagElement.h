//
//  CloudTagElement.h
//  YapZap
//
//  Created by Jason R Boggess on 2/18/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Tag;


@interface CloudTagElement : NSObject
-(CloudTagElement*)initWithTag:(Tag*)tag withPopularity:(NSUInteger)pop inView:(UIView*)view andOnclick:(void (^)(Tag*))onclick;

@property (nonatomic) CGFloat time;
@property (nonatomic) CGPoint position;
@property (nonatomic) CGFloat canvasWidth;
@property (nonatomic, readonly) CGFloat height;
@property (nonatomic, readonly) CGFloat width;

-(void)removeFromSuperView;
@end
