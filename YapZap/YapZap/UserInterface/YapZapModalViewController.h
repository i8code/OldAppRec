//
//  YapZapModalViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/24/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YapZapModalViewController : YapZapViewController

@property (nonatomic, strong) UIButton* backButton;
@property (nonatomic, strong) UIButton* homeButton;
-(void)homePressed:(id)sender;
-(void)backPressed:(id)sender;
@end
