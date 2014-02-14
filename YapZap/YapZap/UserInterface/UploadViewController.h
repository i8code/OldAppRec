//
//  UploadViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UploadViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
-(void) updateProgress;
@property (weak, nonatomic) IBOutlet UILabel *doneLabel;

@end
