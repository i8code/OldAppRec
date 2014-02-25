//
//  IndexedViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IndexedViewController : YapZapViewController
@property (assign, nonatomic) NSInteger index;

-(UIColor*)getBackgroundColor;

@end
