//
//  SetTagViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SetTagViewController.h"
#import "MoodSelectView.h"
#import "SharingBundle.h"

@interface SetTagViewController ()

@property (nonatomic, strong) SharingBundle* sharingBundle;
@property (nonatomic) BOOL hasSelectedMood;
@end

@implementation SetTagViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.hasSelectedMood = false;
    self.sharingBundle = [SharingBundle getCurrentSharingBundle];
	// Do any additional setup after loading the view.
    if ([self.tagTextField respondsToSelector:@selector(setAttributedPlaceholder:)]) {
        UIColor *color = [UIColor grayColor];
        self.tagTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"TAG ME" attributes:@{NSForegroundColorAttributeName: color}];
    } else {
        NSLog(@"Cannot set placeholder text's color, because deployment target is earlier than iOS 6.0");
        // TODO: Add fall-back code to set placeholder color.
    }
    
    self.tagTextField.delegate = self;
    self.tagTextField.text = self.sharingBundle.tagName;
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 5, 20)];
    self.tagTextField.leftView = paddingView;
    self.tagTextField.leftViewMode = UITextFieldViewModeAlways;
    self.waveformImage.filterColor = [UIColor whiteColor];
    [self.waveformImage setImage:self.sharingBundle.waveformImage];
    [self.waveformBorderX setImage:self.sharingBundle.waveformImage];
    [self.waveformBorderY setImage:self.sharingBundle.waveformImage];
    [self.moodSelector setColorDelegate:self];
    
    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backButton.hidden=NO;
    self.parent.homeButton.hidden = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define MAXLENGTH 25

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    

    
    NSUInteger oldLength = [textField.text length];
    NSUInteger replacementLength = [string length];
    NSUInteger rangeLength = range.length;
    
    NSUInteger newLength = oldLength - rangeLength + replacementLength;
    
    BOOL returnKey = [string rangeOfString: @"\n"].location != NSNotFound;
    
    if (newLength <= MAXLENGTH || returnKey){
        NSRange lowercaseCharRange;
        lowercaseCharRange = [string rangeOfCharacterFromSet:[NSCharacterSet lowercaseLetterCharacterSet]];
        
        if (lowercaseCharRange.location != NSNotFound) {
            
            textField.text = [textField.text stringByReplacingCharactersInRange:range
                                                                     withString:[string uppercaseString]];
            return NO;
        }
        return YES;
    }
    
    return NO;
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    if (!self.hasSelectedMood){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Mood" message:@"Please select a mood before continuing." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    return true;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)setMoodColor:(UIColor *)color{
    self.waveformImage.filterColor = color;
    self.parent.background.filterColor = color;
    
    self.hasSelectedMood = YES;
    
    [[SharingBundle getCurrentSharingBundle] setMoodAndIntensity:color];
}
@end
