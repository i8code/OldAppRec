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
    self.sharingBundle = [SharingBundle getCurrentSharingBundle];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    self.tagTextField.delegate = self;
    self.waveformImage.filterColor = [UIColor whiteColor];
    self.backgroundImage.filterColor = [UIColor whiteColor];
    [self.waveformImage setImage:self.sharingBundle.waveformImage];
    [self.waveformBorderX setImage:self.sharingBundle.waveformImage];
    [self.waveformBorderY setImage:self.sharingBundle.waveformImage];
    [self.backgroundImage setImage:[UIImage imageNamed:@"background.png"]];
    [self.moodSelector setColorDelegate:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}
-(void)setMoodColor:(UIColor *)color{
    self.waveformImage.filterColor = color;
    self.backgroundImage.filterColor = color;
}
- (IBAction)goBack:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)homePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}
@end
