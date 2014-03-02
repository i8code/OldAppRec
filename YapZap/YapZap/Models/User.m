//
//  User.m
//  YapZap
//
//  Created by Jason R Boggess on 3/2/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "User.h"

@implementation User

-(NSString*)qualifiedUsername{
    return [NSString stringWithFormat:@"FB%@_%@", self.username, self.displayName];
}

+(User*)getUser{
    static User* user;
    
    if (!user){
        user = [[User alloc] init];
    }
    
    return user;
}

@end
