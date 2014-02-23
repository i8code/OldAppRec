//
//  UploadViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/13/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "UploadViewController.h"

@interface UploadViewController ()

@property int count;
@property (nonatomic, strong) NSTimer* timer;

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
    self.progressBar.progress=0;
    self.doneLabel.hidden = YES;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress)userInfo:nil repeats:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) updateProgress{
    self.count++;
    [self.progressBar setProgress:self.count/20.0];
    if (self.count>20){
        self.doneLabel.hidden = NO;
    }
    if (self.count>30){
        [self.timer invalidate];
        self.timer = nil;
        
        [self.navigationController.view removeFromSuperview];
        [self.navigationController removeFromParentViewController];
    }
    
}

@end
