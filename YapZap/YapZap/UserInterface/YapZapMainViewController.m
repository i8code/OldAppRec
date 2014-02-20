//
//  YapZapMainViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/19/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "YapZapMainViewController.h"
#import "FilteredImageView.h"
#import "UIPopoverController+iPhone.h"
#import "SearchViewController.h"

@interface YapZapMainViewController ()
@property (nonatomic, retain) UIPopoverController *poc;

@end

@implementation YapZapMainViewController

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

    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)createMainButtons{
    
    [self.searchButton removeFromSuperview];
    self.searchButton = [[UIButton alloc] init];
    [self.searchButton setTitle:@"" forState:UIControlStateNormal];
    [self.searchButton setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal];
    
    [self.searchButton setFrame:CGRectMake(
                                           (self.view.frame.size.width-25)/2.0,
                                           5, 25, 25)];
    [self.view addSubview:self.searchButton];
    [self.searchButton addTarget:self
                          action:@selector(searchPressed:)
     forControlEvents:UIControlEventTouchDown];
    self.searchButton.showsTouchWhenHighlighted = YES;
    
    [self.settingsButton removeFromSuperview];
    self.settingsButton = [[UIButton alloc] init];
    [self.settingsButton setTitle:@"" forState:UIControlStateNormal];
    [self.settingsButton setImage:[UIImage imageNamed:@"gear_icon.png"] forState:UIControlStateNormal];
    
    [self.settingsButton setFrame:CGRectMake(
                                             (self.view.frame.size.width-30),
                                             5, 25, 25)];
    [self.view addSubview:self.settingsButton];
    self.settingsButton.showsTouchWhenHighlighted = YES;
    [self.settingsButton addTarget:self
                          action:@selector(showSettings:)
                forControlEvents:UIControlEventTouchDown];
    
    
    
    [self.backButton removeFromSuperview];
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    
    [self.backButton setFrame:CGRectMake(5, 5, 25, 25)];
    [self.view addSubview:self.backButton];
    self.backButton.hidden= YES;
    self.backButton.showsTouchWhenHighlighted = YES;
    
    
    [self.recordButton removeFromSuperview];
    self.recordButton = [[UIButton alloc] init];
    [self.recordButton setTitle:@"" forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    
    [self.recordButton setFrame:CGRectMake((self.view.frame.size.width-75)/2.0, self.view.frame.size.height-90, 75, 75)];
    [self.view addSubview:self.recordButton];
    self.recordButton.showsTouchWhenHighlighted = YES;
    [self.recordButton addTarget:self
                          action:@selector(startRecording:)
                forControlEvents:UIControlEventTouchDown];
    
    
}

-(void)createBackground{
    
    [self.background removeFromSuperview];
    self.background = [[FilteredImageView alloc] init];
    self.background.filterColor = [UIColor whiteColor];
    [self.background setImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:self.background];
    [self.background setContentMode:UIViewContentModeScaleToFill];
    [self.background setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view sendSubviewToBack:self.background];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createBackground];
    [self createMainButtons];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (IBAction)searchPressed:(id)sender {
    UIButton* me = sender;
    UIViewController *detailsViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    self.poc = [[UIPopoverController alloc] initWithContentViewController:detailsViewController];
    CGRect bounds = CGRectMake(me.frame.origin.x, me.frame.origin.y, me.frame.size.width, me.frame.size.height);
    [self.poc presentPopoverFromRect:bounds inView:self.view  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.poc.contentViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    self.poc.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
}

- (IBAction)startRecording:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"recordNav"] animated:NO completion:nil];
}
- (IBAction)showSettings:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    [self presentViewController:[storyboard instantiateViewControllerWithIdentifier:@"settings"] animated:YES completion:nil];
}

@end
