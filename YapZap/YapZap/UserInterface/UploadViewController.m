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

-(NSString*)getTwitterMessage{
    NSString* link = [NSString stringWithFormat:@"%@://%@/a/%@/%@", PROTOCOL, HOST, self.uploadedRecording.tagName, self.uploadedRecording.audioHash];
    NSString* downloadLink = [NSString stringWithFormat:@"%@://%@/app", PROTOCOL, HOST];
    NSString* messageBody = [NSString stringWithFormat:@"Hear what I think about #%@ %@. Join the convo on YapZap %@", self.uploadedRecording.tagName, link, downloadLink];
    
    return messageBody;
}

-(void)shareOnFB{
    
    [FBRequestConnection startForPostStatusUpdate:[self getTwitterMessage]
                                completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                                    if (!error) {
                                        // Status update posted successfully to Facebook
                                        NSLog([NSString stringWithFormat:@"result: %@", result]);
                                    } else {
                                        // An error occurred, we need to handle the error
                                        // See: https://developers.facebook.com/docs/ios/errors
                                        NSLog([NSString stringWithFormat:@"%@", error.description]);
                                    }
                                }];
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
                
                NSString* messageBody = [self getTwitterMessage];
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
        
        NSLog(@"Starting upload");
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
        
        NSLog(@"Uploading %@\n to \n", jsonBody);
        NSString* recordingURL;
        if ([bundle comment]){
            recordingURL = [NSString stringWithFormat:@"/recordings/%@/recordings", recordingToCreate.parentName];
        }
        else {
            recordingURL = [NSString stringWithFormat:@"/tags/%@/recordings", [recordingToCreate.parentName lowercaseString]];
        }
        
        NSLog(@"Uploading %@\n to \n%@", jsonBody,recordingURL);
        [RestHelper post:recordingURL withBody:jsonBody andQuery:nil completion:^(NSString* recordingResponse) {
            if (!recordingResponse){
                NSLog(@"There was an error during upload");
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showError];
                });
                return;
            }
            
            NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:[recordingResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
            self.uploadedRecording = [Recording fromJSON:jsonResponse];
            
            NSLog(@"Uploaded recording: \n%@", [recordingResponse dataUsingEncoding:NSUTF8StringEncoding]);
            
            //Now share on FB/Twitter
            
            if ([Util shouldShareOnFB] && [self.uploadedRecording.parentType isEqualToString:@"TAG"]){
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound) {
                        // permission does not exist
                        [[FBSession activeSession] requestNewPublishPermissions:[Util getFBWritePermissions]    defaultAudience:FBSessionDefaultAudienceEveryone completionHandler:^(FBSession *session, NSError *error) {
                            /* handle success + failure in block */
                            if (!error){
                                NSLog(@"Sharing on Facebook");
                                [self shareOnFB];
                            }else {
                                
                                NSLog(@"Error getting permission to share on Facebook");
                            }
                        }];
                    } else {
                        NSLog(@"Sharing on Facebook");
                        [self shareOnFB];
                    }
                    
                });
            }
            
            if ([Util shouldShareOnTW] && [self.uploadedRecording.parentType isEqualToString:@"TAG"]){
                NSLog(@"Sharing on Twitter");
                [self shareOnTW];
            }
            
            
            //Delete recording
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            
            [[LocalyticsSession shared] tagEvent:@"Finished Upload"];
            NSLog(@"Finished upload");
            
            self.uploadComplete = YES;
            [Util setHasYapped];
        

        }];
        
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
