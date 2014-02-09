//
//  SetTagViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetTagViewController : UIViewController <UITextFieldDelegate>
- (IBAction)homePressed:(id)sender;
@property (weak, nonatomic) IBOutlet UITextField *tagTextField;

@end
