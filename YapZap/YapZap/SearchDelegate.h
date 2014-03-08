//
//  SearchDelegate.h
//  YapZap
//
//  Created by Jason R Boggess on 3/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SearchDelegate <NSObject>
-(void)searchTermSelected:(NSString*)term;

@end
