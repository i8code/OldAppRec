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

static long lastTime = 0;

-(id)init{
    self = [super init];
    self.enteredApp = false;
    
    return self;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:UIScreen.mainScreen.bounds];
    [self.window setRootViewController:[[LoadingViewController alloc] initWithNibName:@"LoadingViewController" bundle:nil]];
    [self.window makeKeyAndVisible];
    
    [[AVAudioSession sharedInstance] setCategory:AVAudioSessionCategoryPlayback error:nil];
    [[AVAudioSession sharedInstance] setActive: YES error: nil];
    [self registerForAudioObjectNotifications];
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    self.player = [MasterAudioPlayer instance];
    [self.player setUpHeadsetListener];
    lastTime = (long)[[NSDate date] timeIntervalSince1970];
    
    [TestFlight takeOff:@"e1a305e1-e4eb-47d7-9c7c-108accb8f261"];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if (![Util hasAgreedToTerms]){
        [Util setDefaults];
    }
    
    /*NSArray* recordings = [DataSource getRecordingsForTagName:@"familyguy"];
    [self.player play:recordings[0] fromTagSet:recordings];
    
    return YES;*/
    
    
    [CoreDataManager database];
    /*
    
   dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       
       while (!self.hasAuthedWithFacebook){
           [NSThread sleepForTimeInterval:1];
       }
       
       [self gotoLoadingView];
   
       //Load Tag names
       [DataSource getTimezoneOffset:^{
           [self goToHomeView];
           self.enteredApp = true;
           
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [DataSource updateFacebookFriends];
            });
       }];
       
       
       
    });
    
    
    //Check to see if the user is logged in
    
//    [Util clearSearchHistory];
/ *
     dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
         dispatch_async(dispatch_get_main_queue(), ^{
             NSLog(@"Prompting for Twitter Auth login");
             [self askForTwitterAuth];
             NSLog(@"Prompting for Facebook login");
             [self loginFacebook];
         });
    });
    */
        
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    [[LocalyticsSession shared] LocalyticsSession:@"0cd3459f7fc0e11fcbfc7d2-8c4106bc-ac5f-11e3-4230-00a426b17dd8"];
    [[LocalyticsSession shared] resume];
    [[LocalyticsSession shared] upload];
    
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


#ifdef DEBUG

@implementation NSURLRequest(DataController)
+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}
@end

#endif