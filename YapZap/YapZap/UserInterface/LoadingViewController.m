//
//  LoadingViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "LoadingViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import <Twitter/Twitter.h>
#import <Social/Social.h>
#import <Accounts/Accounts.h>
#import "UIAlertView+Blocks.h"
#import "User.h"
#import "AppDelegate.h"

@interface LoadingViewController ()

@end

@implementation LoadingViewController

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
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter]addObserver:self
                                            selector:@selector(viewDidAppear:)
                                                name:UIApplicationDidBecomeActiveNotification
                                              object:nil];
}

-(void)viewWillAppear:(BOOL)animated{
//    self.activityView.frame = CGRectMake(self.view.frame.size.width/2-18.5, self.view.frame.size.height/2-18.5, 37, 37);
}

-(void)viewDidAppear:(BOOL)animated{
    
    self.activityView.hidden = NO;
    self.facebookAccountLabel.hidden = YES;
    [self askForTwitterAuth];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)askForFacebookAuth{
    ACAccountStore *store = [[ACAccountStore alloc] init]; // Long-lived
    ACAccountType *facebookType = [store accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    
    NSDictionary *options = @{
                              ACFacebookAppIdKey: @"587695657976183",
                              ACFacebookPermissionsKey: @[@"basic_info"],
                              ACFacebookAudienceKey: ACFacebookAudienceEveryone
                              };
    
    [store requestAccessToAccountsWithType:facebookType options:options completion:^(BOOL granted, NSError* err){
        
        if (!granted){
            dispatch_async(dispatch_get_main_queue(), ^{
                self.activityView.hidden = YES;
                self.facebookAccountLabel.hidden = NO;
            });
            
            return;
        }
        
        NSArray *accountsArray = [store accountsWithAccountType:facebookType];
        ACAccount *facebookAccount = [accountsArray objectAtIndex:0];
        User* user = [User getUser];
        user.username = facebookAccount.username;
        user.displayName = facebookAccount.userFullName;
        user.fbID = [facebookAccount valueForKeyPath:@"properties.uid"];
        
        AppDelegate* app = [[UIApplication sharedApplication] delegate];
        [app goToHomeView];
        
    }];
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
        
        [self askForFacebookAuth];
        
    }];
}



-(UIColor*)getBackgroundColor{
    return nil;
    
}

@end
