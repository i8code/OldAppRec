//
//  User.h
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>

@interface User : NSObject
@property(nonatomic, strong) NSString* displayName;
@property(nonatomic, strong) NSString* username;
@property(nonatomic, strong) NSString* fbID;

-(NSString*)qualifiedUsername;

+(User*)getUser;
+(bool)hasLoggedIn;
+(User*)fromFBUser:(NSDictionary<FBGraphUser>*)user;

@end
