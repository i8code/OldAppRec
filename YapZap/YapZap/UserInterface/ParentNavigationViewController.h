//
//  ParentNavigationViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YapZapMainControllerProtocol.h"
#import "YapZapMainViewController.h"

@interface ParentNavigationViewController : UINavigationController<YapZapMainControllerProtocol>
@property (nonatomic, weak) YapZapMainViewController* parent;
@end
