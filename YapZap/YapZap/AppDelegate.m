//
//  AppDelegate.m
//  YapZap
//
//  Created by Jason R Boggess on 2/4/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "AppDelegate.h"
#import "TestFlight.h"
#import "YapZapMainViewController.h"
#import "TagCloudViewController.h"
#import "ParentNavigationViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "User.h"
#import "DataSource.h"
#import "CoreDataManager.h"
#import "LoadingViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "LocalyticsSession.h"
#import "MasterAudioPlayer.h"

@interface AppDelegate()
@property (nonatomic, strong) UIImageView *splashScreen;
@property (nonatomic, strong) MasterAudioPlayer* player;

@end
@implementation AppDelegate

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    self.splashScreen = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"LaunchImage_IPhone5.png"]];
    [self.splashScreen setContentMode:UIViewContentModeScaleAspectFill];
    self.splashScreen.frame = self.window.bounds;
    [self.window addSubview:self.splashScreen];
    [self.window makeKeyAndVisible];
    [self gotoLoadingView];
    
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [self registerForAudioObjectNotifications];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    self.player = [MasterAudioPlayer instance];
    
    /*NSArray* recordings = [DataSource getRecordingsForTagName:@"familyguy"];
    [self.player play:recordings[0] fromTagSet:recordings];
    
    return YES;*/
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [TestFlight takeOff:@"0b2d5b64-2406-45ef-8532-50cb4c43d8b5"];
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
        
        [DataSource getTimezoneOffset];
        
        
        //Load Tag names
        [DataSource getTagNames];
        [DataSource updateFacebookFriends];
        [CoreDataManager database];
    });
    
    
    //Check to see if the user is logged in
    
//    [Util clearSearchHistory];

     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"Prompting for Twitter Auth login");
             [self askForTwitterAuth];
             NSLog(@"Prompting for Facebook login");
             [self loginFacebook];
         });
    });
    
        
//    
//    {
//        
//        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        [self setActiveView:[storyboard instantiateViewControllerWithIdentifier:@"recording"]];
//        
//    }
    // Override point for customization after application launch.
    
    return YES;
}

-(void)setActiveView:(UIViewController*)viewController{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.splashScreen){
            [self.splashScreen removeFromSuperview];
            self.splashScreen = nil;
        }
        [self.window setRootViewController:viewController];
        [self.window makeKeyAndVisible];
    });
}

-(void)gotoLoadingView{
    [self setActiveView:[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil]];
}

-(void)goToLoginView{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self setActiveView:[storyboard instantiateViewControllerWithIdentifier:@"login"]];
}
-(void)goToHomeView{
    YapZapMainViewController* mainViewController =[[YapZapMainViewController alloc] init];
    [self setActiveView:mainViewController];
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    [[NSUserDefaults standardUserDefaults] synchronize];
    [[LocalyticsSession shared] close];
    [[LocalyticsSession shared] upload];
}

#pragma Facebook
-(void)loginFacebook{
    // Whenever a person opens the app, check for a cached session
    if (FBSession.activeSession.state == FBSessionStateCreatedTokenLoaded) {
        NSLog(@"Found a cached session");
        // If there's one, just open the session silently, without showing the user the login UI
        [FBSession openActiveSessionWithReadPermissions:[Util getFBReadPermissions] 
                                              allowLoginUI:NO
                                      completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                          // Handler for session state changes
                                          // This method will be called EACH time the session state changes,
                                          // also for intermediate states and NOT just when the session open
                                          [self sessionStateChanged:session state:state error:error];
                                      }];
        
        // If there's no cached session, we will show a login button
    } else {
        [self goToLoginView];
    }
}

// This method will handle ALL the session state changes in the app
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Facebook Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Facebook Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Facebook Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI
- (void)userLoggedOut
{
    [self goToLoginView];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    [FBRequestConnection startForMeWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
        if (!error) {
            NSLog(@"%@",result);
            // Success! Include your code to handle the results here
            [User getUser].displayName = [result objectForKey:@"name"];
            [User getUser].fbID = [result objectForKey:@"id"];
            [User getUser].username = [result objectForKey:@"username"];
        } else {
            // An error occurred, we need to handle the error
            // See: https://developers.facebook.com/docs/ios/errors
        }
    }];
    
    [self goToHomeView];
}

// Show an alert message
- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    return [FBSession.activeSession handleOpenURL:url];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    [[LocalyticsSession shared] LocalyticsSession:@"0cd3459f7fc0e11fcbfc7d2-8c4106bc-ac5f-11e3-4230-00a426b17dd8"];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [FBSession.activeSession handleOpenURL:url];
}

-(void)askForTwitterAuth{
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *twitterType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    [store requestAccessToAccountsWithType:twitterType options:nil completion:^(BOOL granted, NSError* err){
        
        if(!granted) {
            [Util setShareOnTW:NO];
        }
        else {
            NSArray *accountsArray = [store accountsWithAccountType:twitterType];
            
            if ([accountsArray count] < 1) {
                [Util setShareOnTW:NO];
            }
        }

    }];
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

- (void) registerForAudioObjectNotifications {
    
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter addObserver: self
                           selector: @selector (remoteControlReceivedWithEvent:)
                               name: @"MixerHostAudioObjectPlaybackStateDidChangeNotification"
                             object: nil];
}


- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    
    if (receivedEvent.type == UIEventTypeRemoteControl) {

        switch (receivedEvent.subtype) {
                
            case UIEventSubtypeRemoteControlPlay:
                [self.player playCurrent];
                break;
                
            case UIEventSubtypeRemoteControlPause:
            case UIEventSubtypeRemoteControlStop:
                [self.player stop];
                break;
            case UIEventSubtypeRemoteControlTogglePlayPause:
                [self.player togglePlayback];
                break;
            case UIEventSubtypeRemoteControlNextTrack:
                [self.player next];
                break;
            case UIEventSubtypeRemoteControlPreviousTrack:
                [self.player previous];
                break;
            default:
                break;
        }
    }
}
@end