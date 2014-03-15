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
    
    // Put together the dialog parameters
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                   @"Sharing Tutorial", @"name",
                                   @"Build great social apps and get more installs.", @"caption",
                                   @"Allow your users to share stories on Facebook from your app using the iOS SDK.", @"description",
                                   @"https://developers.facebook.com/docs/ios/share/", @"link",
                                   @"http://i.imgur.com/g3Qc1HN.png", @"picture",
                                   nil];
    
    // Make the request
    [FBRequestConnection startWithGraphPath:@"/me/feed"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                              if (!error) {
                                  // Link posted successfully to Facebook
                                  NSLog([NSString stringWithFormat:@"result: %@", result]);
                              } else {
                                  // An error occurred, we need to handle the error
                                  // See: https://developers.facebook.com/docs/ios/errors
                                  NSLog([NSString stringWithFormat:@"%@", error.description]);
                              }
                          }];
}

-(void)shareOnTW{
    
    ACAccountStore *account = [[ACAccountStore alloc] init];
    ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    NSString *message = @"Message";
    //hear before posting u can allow user to select the account
    NSArray *arrayOfAccons = [account accountsWithAccountType:accountType];
    for(ACAccount *acc in arrayOfAccons)
    {
        NSLog(@"%@",acc.username); //in this u can get all accounts user names provide some UI for user to select,such as UITableview
    }
    
    
    NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                  @"/1.1/statuses/user_timeline.json"];
    NSDictionary *params = @{@"screen_name" : message,
                             @"forKey":@"status",
                             @"trim_user" : @"1",
                             @"count" : @"1"};
    // Request access from the user to access their Twitter account
    
    [account requestAccessToAccountsWithType:accountType options:nil completion:^(BOOL granted, NSError *error)
     
     {
         if (granted == YES)
         {
             // Populate array with all available Twitter accounts
             NSArray *arrayOfAccounts = [account accountsWithAccountType:accountType];
             if ([arrayOfAccounts count] > 0)
             {
                 //use the first account available
                 ACAccount *acct = [arrayOfAccounts objectAtIndex:0]; //hear this line replace with selected account. than post it :)
                 
                 
                 
                 
                 SLRequest *request =
                 [SLRequest requestForServiceType:SLServiceTypeTwitter
                                    requestMethod:SLRequestMethodPOST
                                              URL:url
                                       parameters:params];
                 
                 
                 //Post the request
                 [request setAccount:acct];
                 
                 //manage the response
                 [request performRequestWithHandler:^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error)
                  {
                      if(error)
                      {
                          //if there is an error while posting the tweet
                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Error in posting" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                          
                      }
                      else
                      {
                          // on successful posting the tweet
                          NSLog(@"Twitter response, HTTP response: %lu", [urlResponse statusCode]);
                          UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Successfully posted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                          [alert show];
                          
                          
                      }
                  }];
                 
             }
             else
             {
                 UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"You have no twitter account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 [alert show];
                 
             }
         }
         else
         {
             //suppose user not set any of the accounts
             UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Twitter" message:@"Permission not granted" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
             [alert show];
             
         }
     } ];
    
}

-(void)upload{
    Recording* recordingToCreate = [[SharingBundle getCurrentSharingBundle] asNewRecording];
    self.uploadComplete = NO;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
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
            [self shareOnFB];
        }
        
        if ([Util shouldShareOnTW]){
            [self shareOnTW];
        }
        
        
        //Delete recording
        [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        
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
