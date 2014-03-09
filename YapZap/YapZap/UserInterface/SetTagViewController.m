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
#import "SearchTableViewController.h"

@interface SetTagViewController ()

@property (nonatomic, strong) SharingBundle* sharingBundle;
@property (nonatomic, strong) SearchTableViewController* searchTableView;
@property (nonatomic) BOOL hasSelectedMood;
@property (nonatomic) BOOL backPressedLast;
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
    
    self.zeusFace.image = [UIImage imageNamed:@"zeus elements-11.png"];
    
    self.tagTextField.hidden = self.sharingBundle.comment;
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
    
    [self.glowBolt setImage:[UIImage imageNamed:@"bolt_glow.png"]];
    self.glowBolt.filterColor = [UIColor whiteColor];
    
    
    if (self.searchTableView){
        [self.searchTableView.view removeFromSuperview];
        [self.searchTableView removeFromParentViewController];
    }
    
    self.searchTableView = [[SearchTableViewController alloc] initWithNibName:@"SearchTableViewController" bundle:nil];
        self.searchTableView.delegate = self;
        
    [self addChildViewController:self.searchTableView];
    [self.autoFillZone addSubview:self.searchTableView.view];
    [self.searchTableView.view setFrame:self.autoFillZone.bounds];
    
    self.autoFillZone.hidden=YES;

    

}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backButton.hidden=NO;
    self.parent.homeButton.hidden = NO;
}


-(void)homePressed:(id)sender{
    //There is an active recording
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                    message:@"Are you sure you want to delete this recording?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    self.backPressedLast=NO;
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [SharingBundle getCurrentSharingBundle].recordingInfo = nil;
        if (self.backPressedLast){
            [super backPressed:self];
        }else {
            [super homePressed:nil];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#define MAXLENGTH 25

- (BOOL)textField:(UITextField *) textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    NSString* newText = [textField.text stringByReplacingCharactersInRange:range
                                                                withString:[string uppercaseString]];
    
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
            [self.searchTableView setSearchTerms:newText];
            return NO;
        }
        [self.searchTableView setSearchTerms:newText];
        return YES;
    }
    return NO;
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
}
-(NSString*)fixTag{
    NSString* tagname = self.tagTextField.text;
    tagname = [[[tagname componentsSeparatedByCharactersInSet:[[NSCharacterSet alphanumericCharacterSet] invertedSet]] componentsJoinedByString:@""] uppercaseString];
    
    return tagname;
    
}
-(BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender{
    NSString* tagname = [self fixTag];
    [self.sharingBundle setTagName:tagname];
    if (!tagname || !tagname.length) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Tag Name" message:@"Please tag before continuing." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    if (!self.hasSelectedMood){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Select Mood" message:@"Please select a mood before continuing." delegate:self cancelButtonTitle:@"Ok" otherButtonTitles: nil];
        [alert show];
        return false;
    }
    
    return true;
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    self.autoFillZone.hidden=NO;
    return YES;
}
-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    self.autoFillZone.hidden=YES;
    return YES;
}
-(void)setMoodColor:(UIColor *)color{
    self.waveformImage.filterColor = color;
    self.glowBolt.filterColor = color;
    
    self.hasSelectedMood = YES;
    
    [[SharingBundle getCurrentSharingBundle] setMoodAndIntensity:color];
    [self setAngle:[Util moodFromColor:color]];
}
-(void)setAngle:(CGFloat)angle{
    
    static NSArray* zeuesInOrder;
    
    if (!zeuesInOrder){
        zeuesInOrder= [NSArray arrayWithObjects:
                    @"zeus elements-13.png",
                    @"zeus elements-12.png",
                    @"zeus elements-14.png",
                    @"zeus elements-10.png",
                    @"zeus elements-09.png",
                    @"zeus elements-08.png",
                    nil
                    ];
    }
    
    static int last = -1;
    
    angle*=360.0;
    angle=420-angle;
    if (angle>360){
        angle-=360;
    }
    int i=0;
    for (i=60;i<360;i+=60){
        if (angle<i){
            break;
        }
    }
    i/=60.1;
    
    if (i!=last){
        last=i;
        self.zeusFace.image = [UIImage imageNamed:zeuesInOrder[i]];
    }
    
}
-(void)searchTermSelected:(NSString *)term{
    self.tagTextField.text = term;
    [self.tagTextField resignFirstResponder];
    self.autoFillZone.hidden=YES;
}
@end
