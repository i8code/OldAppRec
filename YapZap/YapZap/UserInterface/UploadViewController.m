//
//  UploadViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "UploadViewController.h"
#import "Recording.h"
#import "SharingBundle.h"
#import "S3Helper.h"
#import "RestHelper.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Social/Social.h>
#import "RestHelper.h"
#import "User.h"

@interface UploadViewController ()

@property int count;
@property int uploadedTime;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic) BOOL uploadComplete;
@property (nonatomic, strong) Recording* uploadedRecording;

@end

@implementation UploadViewController

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
    self.count =0;
    self.uploadedTime=0;
    self.progressBar.progress=0;
    self.doneLabel.hidden = YES;
    self.uploadComplete = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress)userInfo:nil repeats:YES];
    [self upload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backButton.hidden=YES;
    self.homeButton.hidden = YES;
    self.settingsButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)showError{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error uploading the tag. Please try again later" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
}

-(void)shareOnFB{
    // NOTE: pre-filling fields associated with Facebook posts,
    // unless the user manually generated the content earlier in the workflow of your app,
    // can be against the Platform policies: https://developers.facebook.com/policy
    
    NSString* imageURL = [NSString stringWithFormat:@"%@://%@:%d/images/zeus.png", PROTOCOL, HOST, PORT];
    NSString* caption = [NSString stringWithFormat:@"%@ yapped about #%@ on YapZap", [User getUser].displayName, self.uploadedRecording.tagName];
    NSString* description = [NSString stringWithFormat:@"Hear what I think about #%@. Join the conversation on YapZap.", self.uploadedRecording.tagName];
    NSString* link = [NSString stringWithFormat:@"%@://%@:%d/a/%@/%@", PROTOCOL, HOST, PORT, self.uploadedRecording.tagName, self.uploadedRecording.audioHash];
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"YapZap", @"name",
                                   caption, @"caption",
                                   description, @"description",
                                   link, @"link",
                                   imageURL, @"picture",
                                   nil];
    
    // Make the request
    dispatch_async(dispatch_get_main_queue(), ^{
        [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
//                                  NSLog([NSString stringWithFormat:@"result: %@", result]);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
//                                  NSLog([NSString stringWithFormat:@"%@", error.description]);
                              }
                          }];
     });
}

-(void)shareOnTW
{
    
    // Create an account store object.
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    
    // Create an account type that ensures Twitter accounts are retrieved.
    ACAccountType *accountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    // Request access from the user to use their Twitter accounts.
    [accountStore requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error) {
        if(granted) {
            // Get the list of Twitter accounts.
            NSArray *accountsArray = [accountStore accountsWithAccountType:accountType];
            
            if ([accountsArray count] > 0) {
                // Grab the initial Twitter account to tweet from.
                ACAccount *twitterAccount = [accountsArray objectAtIndex:0];
                SLRequest *postRequest = nil;
                
                NSString* link = [NSString stringWithFormat:@"%@://%@:%d/a/%@/%@", PROTOCOL, HOST, PORT, self.uploadedRecording.tagName, self.uploadedRecording.audioHash];
                NSString* messageBody = [NSString stringWithFormat:@"Hear what I think about #%@. Join the convo on YapZap. %@", self.uploadedRecording.tagName, link];
                
                // Post Text
                NSDictionary *message = @{@"status": messageBody};
                
                // URL
                NSURL *requestURL = [NSURL URLWithString:@"https://api.twitter.com/1/statuses/update.json"];
                
                // Request
                postRequest = [SLRequest requestForServiceType:SLServiceTypeTwitter requestMethod:SLRequestMethodPOST URL:requestURL parameters:message];
                
                // Set Account
                postRequest.account = twitterAccount;
                
                // Post
                [postRequest performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
                    NSString* response = [[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding];
                    NSLog(@"Twitter response: %@", response);
                    NSLog(@"Twitter HTTP response: %lu", [urlResponse statusCode]);
                }];
                
            }
        }
    }];

}

-(void)upload{
    Recording* recordingToCreate = [[SharingBundle getCurrentSharingBundle] asNewRecording];
    self.uploadComplete = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        [[LocalyticsSession shared] tagEvent:@"Started Upload"];
        
        SharingBundle* bundle = [SharingBundle getCurrentSharingBundle];
        
        //Upload the recording first
        NSString* path = [[bundle getRecordingPath] relativePath];
        NSData *data = [[NSFileManager defaultManager] contentsAtPath:path];
        [S3Helper saveToS3:data withName:[bundle filename]];
        
        //Now save the Recording object
        NSData* jsonBody = [NSJSONSerialization dataWithJSONObject:recordingToCreate.toJSON options:0 error:nil];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonBody encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonString);
        NSString* recordingURL;
        if ([bundle comment]){
            recordingURL = [NSString stringWithFormat:@"/recordings/%@/recordings", recordingToCreate.parentName];
        }
        else {
            recordingURL = [NSString stringWithFormat:@"/tags/%@/recordings", [recordingToCreate.parentName lowercaseString]];
        }
        NSString* recordingResponse = [RestHelper post:recordingURL withBody:jsonBody andQuery:nil];
        if (!recordingResponse){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError];
            });
            return;
        }
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:[recordingResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.uploadedRecording = [Recording fromJSON:jsonResponse];
        
        //Now share on FB/Twitter
        
        if ([Util shouldShareOnFB]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [[FBSession activeSession] requestNewPublishPermissions:[Util getFBWritePermissions]    defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                    /* handle success + failure in block */
                    if (!error){
                        [self shareOnFB];
                    }
                }];
            });
        }
        
        if ([Util shouldShareOnTW]){
            [self shareOnTW];
        }
        
        
        //Delete recording
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
        [[LocalyticsSession shared] tagEvent:@"Finished Upload"];
        
        self.uploadComplete = YES;
    });
    /*dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0;i<1000;i++){
            if (self.uploadComplete){
                //More here
                return;
            }
            
            [NSThread sleepForTimeInterval:0.1];
            [self.progressBar setProgress:i/10.0];
        }
    });*/
}

-(void) updateProgress{
    self.count++;
    if (self.uploadComplete && self.uploadedTime+10<self.count){
        //Done, done
        [self.timer invalidate];
        self.timer = nil;
        [SharingBundle clear];
        [self dismissViewControllerAnimated:YES completion:^{}];
        
        [self.parent gotoTagWithName:self.uploadedRecording.tagName andRecording:self.uploadedRecording._id];
    }
    else if (self.uploadComplete &&!self.uploadedTime){
        self.doneLabel.hidden = NO;
        self.uploadedTime = self.count;
    }
    else if (self.count>1000){
        [self showError];
        [SharingBundle clear];
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!self.uploadComplete){
        [self.progressBar setProgress:self.count/1000.0];
    }
    else {
        [self.progressBar setProgress:1];
    }
    
}

@end
