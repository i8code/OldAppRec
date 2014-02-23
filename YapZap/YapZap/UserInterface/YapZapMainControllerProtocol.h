//
//  YapZapMainControllerProtocol.h
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YapZapMainViewController.h"

@protocol YapZapMainControllerProtocol <NSObject>

-(void)setParent:(YapZapMainViewController*)parent;

@end
