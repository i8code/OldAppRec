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
#import "YapZapMainControllerProtocol.h"
#import "ParentNavigationViewController.h"
#import "TagCloudViewController.h"
#import "DataSource.h"
#import "TagPageViewController.h"

@interface YapZapMainViewController ()
@property (nonatomic, retain) UIPopoverController *poc;
@property (nonatomic, retain) SettingsViewController *settingsViewController;
@property (nonatomic, retain) UINavigationController* recordNavigationViewController;
@property (nonatomic, retain) UIView* contentView;

@end

@implementation YapZapMainViewController
@synthesize mainViewController = _mainViewController;

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
    me = self;

    
}

-(void)createBottomBar{
    if (!self.bottomBar){
        int height=50;
        CGRect barFrame = CGRectMake(0, self.view.frame.size.height-height, self.view.frame.size.width, height);
        self.bottomBar = [[UIView alloc] initWithFrame:barFrame];
        self.bottomBar.backgroundColor = [[UIColor alloc] initWithRed:0.16 green:0.16 blue:0.16 alpha:0.975];
        self.bottomBar.opaque=NO;
        
        
        [self.view addSubview:self.bottomBar];
    }
    
    
    
    if (!self.font){
        self.font = [UIFont fontWithName:@"Future" size:13];
    }
    
    
    int top=15;
    if (!self.yapLabel){
        CGRect yap = CGRectMake(self.view.frame.size.width/4-13, top, 100, 20);
        self.yapLabel = [[UILabel alloc] initWithFrame:yap];
        [self.yapLabel setFont:self.font];
        [self.yapLabel setText:@"YAP IT"];
        self.yapLabel.backgroundColor = [UIColor clearColor];
        self.yapLabel.opaque=NO;
        [self.yapLabel setTextColor:[UIColor whiteColor]];
        
        [self.bottomBar addSubview:self.yapLabel];
    }
    
    if (!self.zapLabel){
        CGRect zap = CGRectMake(self.view.frame.size.width/2+41, top, 100, 20);
        self.zapLabel = [[UILabel alloc] initWithFrame:zap];
        [self.zapLabel setFont:self.font];
        [self.zapLabel setText:@"ZAP IT"];
        self.zapLabel.backgroundColor = [UIColor clearColor];
        self.zapLabel.opaque=NO;
        [self.zapLabel setTextColor:[UIColor whiteColor]];
        
        [self.bottomBar addSubview:self.zapLabel];
    }
    
    /* Record Button  \/ */
    if (!self.recordButton){
        self.recordButton = [[UIButton alloc] init];
        [self.recordButton setTitle:@"" forState:UIControlStateNormal];
        [self.recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
        
        [self.recordButton setFrame:CGRectMake((self.bottomBar.frame.size.width-46)/2.0, 2, 46, 46)];
        self.recordButton.showsTouchWhenHighlighted = YES;
        [self.recordButton addTarget:self
                              action:@selector(recordingButtonPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        [self.bottomBar addSubview:self.recordButton];
    }
    
    
    
}

-(void)createMainButtons{
    
    int y = 20;
    
    /* Search Button  -o- */
    if (!self.searchButton) {
        self.searchButton = [[UIButton alloc] init];
        [self.searchButton setTitle:@"" forState:UIControlStateNormal];
        [self.searchButton setImage:[UIImage imageNamed:@"search_icon.png"] forState:UIControlStateNormal];
        
        [self.searchButton setFrame:CGRectMake(5,y, 25, 25)];
        [self.view addSubview:self.searchButton];
        [self.searchButton addTarget:self
                          action:@selector(searchPressed:)
                    forControlEvents:UIControlEventTouchUpInside];
        self.searchButton.showsTouchWhenHighlighted = YES;
    }
    
    /* Home Button  -o- */
    if (!self.homeButton){
        self.homeButton = [[UIButton alloc] init];
        [self.homeButton setTitle:@"" forState:UIControlStateNormal];
        [self.homeButton setImage:[UIImage imageNamed:@"home_icon.png"] forState:UIControlStateNormal];
        
        [self.homeButton setFrame:CGRectMake((self.view.frame.size.width-25)/2.0,y+3, 25, 20)];
        [self.view addSubview:self.homeButton];
        [self.homeButton addTarget:self
                            action:@selector(goHome:)
                  forControlEvents:UIControlEventTouchUpInside];
        self.homeButton.showsTouchWhenHighlighted = YES;
    }
    
    
    
    /* Settings Button  --o */
    if (!self.settingsButton) {
        self.settingsButton = [[UIButton alloc] init];
        [self.settingsButton setTitle:@"" forState:UIControlStateNormal];
        [self.settingsButton setImage:[UIImage imageNamed:@"gear_icon.png"] forState:UIControlStateNormal];
        
        [self.settingsButton setFrame:CGRectMake(
                                                 (self.view.frame.size.width-30),y, 25, 25)];
        [self.view addSubview:self.settingsButton];
        self.settingsButton.showsTouchWhenHighlighted = YES;
        [self.settingsButton addTarget:self
                              action:@selector(showSettings:)
                    forControlEvents:UIControlEventTouchUpInside];
    }

    
    
}

-(void)createBackground{
    
    [self.background removeFromSuperview];
    self.background = [[FilteredImageView alloc] init];
    self.background.filterColor = [UIColor whiteColor];
    [self.background setImage:[UIImage imageNamed:@"background.png"]];
    [self.view addSubview:self.background];
    [self.background setContentMode:UIViewContentModeScaleToFill];
    self.background.alpha=0.5;
    [self.background setFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    
    [self.view sendSubviewToBack:self.background];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self createBackground];
    [self createMainButtons];
    
    if (!self.contentView) {
        self.contentView = [[UIView alloc] initWithFrame:CGRectMake(0, self.homeButton.frame.size.height+self.homeButton.frame.origin.y, self.view.frame.size.width, self.view.frame.size.height-self.homeButton.frame.size.height-70)]; //70 is the height of the top bar and bottom bar;
        [self.view addSubview:self.contentView];
    }
    [self createBottomBar];
    
    
    if (!self.mainViewController){
        ParentNavigationViewController* navController = [[ParentNavigationViewController alloc] init];
        [self setMainViewController:navController];
        TagCloudViewController* tagCloudViewController = [[TagCloudViewController alloc] initWithNibName:@"TagCloudViewController" bundle:nil];
        [navController pushViewController:tagCloudViewController animated:NO];

    }
}
-(void)setMainViewController:(UINavigationController *)mainViewController{
    if (_mainViewController){
        [_mainViewController.view removeFromSuperview];
        [_mainViewController removeFromParentViewController];
    }
    
    _mainViewController = (UINavigationController*)mainViewController;
    if ([[_mainViewController class] conformsToProtocol:@protocol(YapZapMainControllerProtocol)]){
        [((id<YapZapMainControllerProtocol>)_mainViewController) setParent:self];
    }
    
    [self addChildViewController:_mainViewController];
    [_mainViewController.view setFrame:self.contentView.bounds];
    [self.contentView addSubview:_mainViewController.view];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchPressed:(id)sender {
    
    [self.stopPlaybackDelegate stopPlayback];
    UIButton* me = sender;
    UIViewController *detailsViewController = [[SearchViewController alloc] initWithNibName:@"SearchViewController" bundle:nil];
    self.poc = [[UIPopoverController alloc] initWithContentViewController:detailsViewController];
    CGRect bounds = CGRectMake(me.frame.origin.x, me.frame.origin.y, me.frame.size.width, me.frame.size.height);
    [self.poc presentPopoverFromRect:bounds inView:self.view  permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    self.poc.contentViewController.view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
    if ([self.poc respondsToSelector:@selector(setBackgroundColor:)]){
        self.poc.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.2];
    }
}

-(void)dismissSearch{
    [self.poc dismissPopoverAnimated:YES];
}

- (IBAction)recordingButtonPressed:(id)sender {
    
    [self.stopPlaybackDelegate stopPlayback];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    self.recordNavigationViewController = [storyboard instantiateViewControllerWithIdentifier:@"recordNav"];
    ((YapZapModalViewController*)[self.recordNavigationViewController.childViewControllers objectAtIndex:0]).parent = self;
    [self presentViewController:self.recordNavigationViewController animated:YES completion:nil];

}
- (IBAction)showSettings:(id)sender {
    
    [self.stopPlaybackDelegate stopPlayback];
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (self.settingsViewController==nil){
        self.settingsViewController =[storyboard instantiateViewControllerWithIdentifier:@"settings"];
    }
    [self presentViewController:self.settingsViewController animated:YES completion:nil];
}

-(IBAction)goHome:(id)sender{
    [self.stopPlaybackDelegate stopPlayback];
    [((UINavigationController*)self.mainViewController) popViewControllerAnimated:YES];
    
}


-(void)gotoTagWithName:(NSString*)tagName{
    //Lots of logic
    //Check to see if we have that tag name
    NSArray* tagNames = [DataSource getTagNames];
    if (![tagNames containsObject:tagName]){
        //If we don't, maybe it's a new tag, refresh names
        tagNames = [DataSource refreshTagNames];
        if (![tagNames containsObject:tagName]){
            return;
        }
    }
    
    //Now see what's visible.
    NSUInteger pages = [[self.mainViewController childViewControllers] count];
    if (pages>1){
        TagPageViewController* visiblePage = [[self.mainViewController childViewControllers] objectAtIndex:pages-1];
        Tag* tag = visiblePage.tag;
        if ([tag.name isEqualToString:tagName]){
            //We good. just refresh
            [visiblePage loadRecordingsForTag];
            return;
        }
    }
    TagCloudViewController* tagCloudViewController = [[self.mainViewController childViewControllers] objectAtIndex:0];
    [tagCloudViewController gotoTagWithName:tagName];
}

-(void)gotoTagWithName:(NSString*)tagName andRecording:(NSString*)recordingId{
    [self gotoTagWithName:tagName];
    [TagPageViewController requestDisplayRecording:recordingId];
}


static YapZapMainViewController* me;


+(YapZapMainViewController*)getMe{
    return me;
}


@end
