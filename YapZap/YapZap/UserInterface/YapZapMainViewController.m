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
#import "SettingsViewController.h"
#import "RecordControllerViewController.h"

@interface YapZapMainViewController ()
@property (nonatomic, retain) UIPopoverController *poc;
@property (nonatomic, retain) SettingsViewController *settingsViewController;
@property (nonatomic, retain) UINavigationController* recordNavigationViewController;

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
    
    /* Search Button  -o- */
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
    
    /* Home Button  -o- */
    [self.homeButton removeFromSuperview];
    self.homeButton = [[UIButton alloc] init];
    [self.homeButton setTitle:@"" forState:UIControlStateNormal];
    [self.homeButton setImage:[UIImage imageNamed:@"home_button.png"] forState:UIControlStateNormal];
    
    [self.homeButton setFrame:CGRectMake((self.view.frame.size.width-25)/2.0,
                                           5, 25, 25)];
    [self.view addSubview:self.homeButton];
    [self.homeButton addTarget:self
                        action:@selector(goHome:)
              forControlEvents:UIControlEventTouchDown];
    self.homeButton.showsTouchWhenHighlighted = YES;
    self.homeButton.hidden = YES;

    
    
    
    /* Settings Button  --o */
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
    
    
    
    /* Back Button  o-- */
    [self.backButton removeFromSuperview];
    self.backButton = [[UIButton alloc] init];
    [self.backButton setTitle:@"" forState:UIControlStateNormal];
    [self.backButton setImage:[UIImage imageNamed:@"back_icon.png"] forState:UIControlStateNormal];
    
    [self.backButton setFrame:CGRectMake(5, 5, 25, 25)];
    [self.view addSubview:self.backButton];
    [self.settingsButton addTarget:self
                            action:@selector(goBack:)
                  forControlEvents:UIControlEventTouchDown];
    self.backButton.hidden= YES;
    self.backButton.showsTouchWhenHighlighted = YES;
    
    
    
    /* Record Button  \/ */
    [self.recordButton removeFromSuperview];
    self.recordButton = [[UIButton alloc] init];
    [self.recordButton setTitle:@"" forState:UIControlStateNormal];
    [self.recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    
    [self.recordButton setFrame:CGRectMake((self.view.frame.size.width-75)/2.0, self.view.frame.size.height-90, 75, 75)];
    [self.view addSubview:self.recordButton];
    self.recordButton.showsTouchWhenHighlighted = YES;
    [self.recordButton addTarget:self
                          action:@selector(recordingButtonPressed:)
                forControlEvents:UIControlEventTouchDown];
    [self.recordButton addTarget:self
                          action:@selector(recordingButtonLifted:)
                forControlEvents:UIControlEventTouchUpOutside];
    [self.recordButton addTarget:self
                          action:@selector(recordingButtonLifted:)
                forControlEvents:UIControlEventTouchUpInside];
    
    
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

- (IBAction)recordingButtonPressed:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//    if (self.recordControllerViewController==nil){
        self.recordNavigationViewController = [storyboard instantiateViewControllerWithIdentifier:@"recordNav"];
//    }
    [self addChildViewController:self.recordNavigationViewController];
    [self.view addSubview:self.recordNavigationViewController.view];
    [self.navigationController didMoveToParentViewController:self];
   // [self presentViewController:self.recordNavigationViewController animated:NO completion:nil];
}


- (IBAction)recordingButtonLifted:(id)sender {
    
    RecordControllerViewController* activeViewController = (RecordControllerViewController*)[self.recordNavigationViewController topViewController];
    
    [activeViewController stopRecording];
}
- (IBAction)showSettings:(id)sender {
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self.settingsViewController==nil){
        self.settingsViewController =[storyboard instantiateViewControllerWithIdentifier:@"settings"];
    }
    [self presentViewController:self.settingsViewController animated:YES completion:nil];
}

-(IBAction)goHome:(id)sender{
    UIViewController* viewController = [[self parentViewController] parentViewController];
    if ([viewController isKindOfClass:[YapZapMainViewController class]]){
        [self.view removeFromSuperview];
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
        for (UIViewController* child in [viewController childViewControllers]){
            [child removeFromParentViewController];
        }
    }
    else {
        [self dismissModalViewControllerAnimated:YES];
    }
}

-(IBAction)goBack:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
