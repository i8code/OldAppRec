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

@synthesize parent = _parent;

-(YapZapMainViewController*)parent{
    return _parent;
}

-(void)setParent:(YapZapMainViewController *)parent{
    _parent = parent;
    
    for (UIViewController* child in self.viewControllers){
        if ([[child class] conformsToProtocol:@protocol(YapZapMainControllerProtocol)]){
            [((id<YapZapMainControllerProtocol>)child) setParent:self.parent];
        }
    }
}

-(void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    
    if ([[viewController class] conformsToProtocol:@protocol(YapZapMainControllerProtocol)]){
        [((id<YapZapMainControllerProtocol>)viewController) setParent:self.parent];
    }
}
@end
