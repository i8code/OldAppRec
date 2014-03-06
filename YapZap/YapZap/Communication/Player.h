//
//  Player.h
//  YapZap
//
//  Created by Jason R Boggess on 3/6/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Player : NSObject
-(Player*)initWithPath:(NSString*)path;
-(void)play;
-(void)stop;
-(void)resume;
-(void)pause;

@end
