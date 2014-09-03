//
//  SettingsViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/9/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "SettingsViewController.h"
#import "AppDelegate.h"
#import "MyRecordingsTableViewController.h"
#import "MyRecordingsCell.h"
#import "User.h"
#import "Recording.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize myRecordingsViewController = _myRecordingsViewController;

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
	// Do any additional setup after loading the view.
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)savePressed:(id)sender {
    [self.currentlyPlayingCell stopPlaying];
    [self dismissViewControllerAnimated:YES completion:^{}];
}
-(void)setRecordings:(NSArray *)recordings{
    _recordings = recordings;
    
    NSUInteger likes = 0;
    NSUInteger comments = 0;
    
    for (Recording* recording in recordings){
        likes+=recording.likes;
        comments+=recording.childrenLength;
    }
    
    self.commentCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)comments];
    self.likeCount.text = [NSString stringWithFormat:@"%lu", (unsigned long)likes];
    
    self.totalNumberLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)self.recordings.count];
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    self.backButton.hidden=YES;
    self.homeButton.hidden = YES;
    self.settingsButton.hidden = YES;
    
    if (!self.myRecordingsViewController){
        self.myRecordingsViewController = [[MyRecordingsTableViewController alloc] initWithNibName:@"MyRecordingsTableViewController" bundle:nil];
        
        self.myRecordingsViewController.delegate = self;
        
        [self addChildViewController:self.myRecordingsViewController];
        [self.manageArea addSubview:self.myRecordingsViewController.view];
        [self.myRecordingsViewController.view setFrame:self.manageArea.bounds];
        
    }
    
    self.usernameLabel.text = [User getUser].displayName;
    self.facebookSwitch.on = [Util shouldShareOnFB];
    self.twitterSwitch.on = [Util shouldShareOnTW];
}

-(void)setCurrentlyPlayingCell:(MyRecordingsCell *)currentlyPlayingCell{
    if (_currentlyPlayingCell && _currentlyPlayingCell!=currentlyPlayingCell){
        [_currentlyPlayingCell stopPlaying];
    }
    _currentlyPlayingCell = currentlyPlayingCell;
    
}

// Handle possible errors that can occur during login
- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    NSString *alertMessage, *alertTitle;
    
    // If the user should perform an action outside of you app to recover,
    // the SDK will provide a message for the user, you just need to surface it.
    // This conveniently handles cases like Facebook password change or unverified Facebook accounts.
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
        
        // This code will handle session closures that happen outside of the app
        // You can take a look at our error handling guide to know more about it
        // https://developers.facebook.com/docs/ios/errors
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
        
        // If the user has cancelled a login, we will do nothing.
        // You can also choose to show the user a message if cancelling login will result in
        // the user not being able to complete a task they had initiated in your app
        // (like accessing FB-stored information or posting to Facebook)
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        NSLog(@"user cancelled login");
        
        // For simplicity, this sample handles other errors with a generic message
        // You can checkout our error handling guide for more detailed information
        // https://developers.facebook.com/docs/ios/errors
    } else {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage) {
        [[[UIAlertView alloc] initWithTitle:alertTitle
                                    message:alertMessage
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
    }
}

- (IBAction)facebookSwitched:(id)sender {
    [[LocalyticsSession shared] tagEvent:@"Toggled Sharing on Facebook"];
    [Util setShareOnFB:self.facebookSwitch.on];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self.twitterSwitch setOn:NO animated:YES];
}

- (IBAction)twitterSwitched:(id)sender {
    [[LocalyticsSession shared] tagEvent:@"Toggled Sharing on Twitter"];
    [Util setShareOnTW:self.twitterSwitch.on];
    
    if (self.twitterSwitch.on){
        
        // Create an account store object.
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        
        // Create an account type that ensures Twitter accounts are retrieved.
        ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
        
        // Request access from the user to use their Twitter accounts.
        [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
            
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Enable Twitter" message:@"You must enable at least one Twitter account in iPhone Settings in order to share on twitter." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            if(!granted) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [alert show];

                });
            }
            else {
                NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
                
                if ([accountsArray count] < 1) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [alert show];
                    });
                }
            }
        }];
    }
}

- (IBAction)getHelp:(id)sender {
    NSString *emailTitle = @"I'm in need of some assistance";
    NSString *messageBody = @"";
    NSArray *toRecipents = [NSArray arrayWithObject:@"zeus@yapzap.me"];
    
    MFMailComposeViewController *mc = [[MFMailComposeViewController alloc] init];
    if (!mc){
        NSString* path = [NSString stringWithFormat:@"mailto:admin@yapzap.me?subject=%@&body=%@", emailTitle, messageBody];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:path]];
    }
    else {
        mc.mailComposeDelegate = self;
        [mc setSubject:emailTitle];
        [mc setMessageBody:messageBody isHTML:YES];
        [mc setToRecipients:toRecipents];
        
        // Present mail view controller on screen
        [self presentViewController:mc animated:YES completion:NULL];
    }
}

- (void) mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    
    // Close the Mail Interface
    [self dismissViewControllerAnimated:YES completion:NULL];
}
- (IBAction)termsOfUseClicked:(id)sender {
    NSURL* url = [NSURL URLWithString:@"https://yapzap.me/terms"];
    [[UIApplication sharedApplication] openURL:url];
}
@end
