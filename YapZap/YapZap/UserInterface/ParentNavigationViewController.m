//
//  ParentNavigationViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/22/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "ParentNavigationViewController.h"

@interface ParentNavigationViewController ()

@end

@implementation ParentNavigationViewController

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if ([[viewController class] conformsToProtocol:@protocol(YapZapMainControllerProtocol)]){
        [((id<YapZapMainControllerProtocol>)viewController) setParent:self.parent];
    }
}
@end
