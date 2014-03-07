//
//  SearchViewController.h
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewController : YapZapViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;

@property (weak, nonatomic) IBOutlet UIView *autofillArea;
@end
