//
//  RecordControllerViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//

#import "RecordControllerViewController.h"

@interface RecordControllerViewController ()

@property (nonatomic, strong) NSTimer* timer;
@property CGFloat hue;
@property CGFloat timerCount;
@property BOOL recording;
@end

@implementation RecordControllerViewController

@synthesize timer = _timer;
@synthesize hue = _hue;
@synthesize timerCount = _timerCount;
@synthesize recording = _recording;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) updateBackgroundColor{
    self.hue = (self.hue+15);
    if (self.hue>360){
        self.hue-=360;
    }
    UIColor* backgroundColor = [UIColor colorWithHue:self.hue/360.0f saturation:1 brightness:1 alpha:1];
    
    //This is confusing \/
    self.backgroundColor.backgroundColor = backgroundColor;
    
    CGFloat width = self.view.frame.size.width;
    width*=(self.timerCount/100.0f);
    [self.waveformImage setFrame:CGRectMake(0, self.waveformImage.frame.origin.y, width, self.waveformImage.frame.size.height)];
    
    if (self.timerCount>=100){
        [self stopRecording];
    }
    self.timerCount++;

    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

-(void)viewDidAppear:(BOOL)animated{
    [self startRecording];
}

-(void) startRecording{
    
    self.recording = true;
    
    self.backgroundColor.hidden = NO;
    self.finishedPanel.hidden = YES;
    self.hue = 0;
    [self.timer invalidate];
    self.timerCount = 0;
    
    [self.recordButton setImage:[UIImage imageNamed:@"stop_button_small.png"] forState:UIControlStateNormal];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateBackgroundColor)userInfo:nil repeats:YES];
}

-(void)stopRecording{
    
    self.recording = false;
    self.backgroundColor.hidden = YES;
    self.finishedPanel.hidden = NO;
    [self.timer invalidate];
    self.timer = nil;
    
    [self.recordButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)homePressed:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

- (IBAction)recordButtonPressed:(id)sender {
    
    if (self.recording){
        [self stopRecording];
    }
    else{
        [self startRecording];
    }
}

- (IBAction)trashButtonPressed:(id)sender {
    [self.waveformImage setFrame:CGRectMake(0, self.waveformImage.frame.origin.y, 0, self.waveformImage.frame.size.height)];
    self.finishedPanel.hidden = YES;
}
- (IBAction)playButtonPressed:(id)sender {
}
@end
