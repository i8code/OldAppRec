//
//  RecordControllerViewController.m
//  YapZap
//
//  Created by Jason R Boggess on 2/8/14.
//  Copyright (c) 2014 YapZap. All rights reserved.
//
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>
#import "RecordControllerViewController.h"
#import "Recorder.h"
#import "RecordingInfo.h"
#import "WaveformView.h"
#import "SharingBundle.h"
#import "FilteredImageView.h"
#import "Player.h"
#import "RecordingFill.h"
#import "UIAlertView+Blocks.h"

@interface RecordControllerViewController ()

@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic, strong) NSTimer* playTimer;
@property CGFloat hue;
@property CGFloat timerCount;
@property CGFloat playTimerCount;
@property BOOL recording;
@property BOOL playing;
@property (nonatomic, strong) Recorder* recorder;
@property (nonatomic, strong) RecordingInfo* recordingInfo;
@property (nonatomic, strong) WaveformView* waveform;
@property (nonatomic, strong) Player *player;
@property (nonatomic) BOOL backPressedLast;
@property (nonatomic) BOOL trashPressedLast;
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
        self.recording = false;
        self.playing =false;
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
    [self.waveform setNeedsDisplay];
    self.waveform.hidden = NO;
    
    if (![self.recorder isRecoring]){
        [self stopRecording:nil];
    }
    self.timerCount++;
    
    
    self.recordingFill.percent = self.timerCount/100.0;
    [self.recordingFill setNeedsDisplay];

    
}

-(void) updatePlayLocation{
    self.playTimerCount++;
    float seconds = self.recordingInfo.length / (float)self.recorder.blockLength*10;
    float percent = self.playTimerCount/(100);
    
    [self.waveform setHighlightPercent:percent];
    [self.waveform setNeedsDisplay];
    
    if (percent>seconds/10.0){
        [self stopPlaying];
    }
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initialize];
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    SharingBundle* bundle = [SharingBundle getCurrentSharingBundle];
    self.finishedPanel.hidden = self.waveform.hidden = !bundle.recordingInfo;
    self.backButton.hidden=NO;
    self.recordingFill.percent = 0;
    [self.recordingFill setNeedsDisplay];
}

-(void)initialize{
    self.recorder = [[Recorder alloc] initWithSeconds:10];
    [self.waveform removeFromSuperview];
    self.waveform = [[WaveformView alloc] init];
    [self.waveform setFrame:CGRectMake(0, self.view.frame.size.height*0.45f, self.view.frame.size.width, 150)];
    [self.view addSubview:self.waveform];
    [self.waveform setData:self.recorder.waveformData withSize:[self.recorder blockLength]];
    
}

-(IBAction)startRecording:(id)sender{
    [[LocalyticsSession shared] tagEvent:@"Started Recording"];
    SharingBundle* bundle = [SharingBundle getCurrentSharingBundle];
    
    if (bundle.recordingInfo){
        //Need to prompt for deletion
        [UIAlertView showWithTitle:@"Confirm Delete" message:@"Are you sure you want to delete this recording?" cancelButtonTitle:@"Cancel" otherButtonTitles:@[@"OK"] tapBlock:^(UIAlertView *alertView, NSInteger buttonIndex) {
            if (buttonIndex!=[alertView cancelButtonIndex]){
                bundle.recordingInfo = nil;
                self.finishedPanel.hidden = self.waveform.hidden = !bundle.recordingInfo;
                self.recordingFill.percent = 0.0;
                [self.recordingFill setNeedsDisplay];
            }
        }];
        return;
    }
    
    
    if (self.playing)
    {
        [self stopPlaying];
    }
    self.recording = true;
    
    self.backgroundColor.hidden = NO;
    self.finishedPanel.hidden = YES;
    self.hue = 0;
    [self.timer invalidate];
    self.timerCount = 0;
    
    [self.recordActiveButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    
    [self.recorder start];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateBackgroundColor)userInfo:nil repeats:YES];
}

-(IBAction)stopRecording:(id)sender{
    [[LocalyticsSession shared] tagEvent:@"Stopped Recording"];
    
    self.recording = false;
    self.backgroundColor.hidden = YES;
    self.finishedPanel.hidden = NO;
    [self.timer invalidate];
    self.timer = nil;
    [self.recorder stop];
    self.recordingInfo = [self.recorder lastInfo];
    [[SharingBundle getCurrentSharingBundle] setRecordingInfo:self.recordingInfo];
    
    
    
    float seconds = self.recordingInfo.length / (float)self.recorder.blockLength*10;
    if (seconds<0.5){
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Hold to Record" message:@"You must hold the record button down to record." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        self.waveform.hidden = YES;
        self.finishedPanel.hidden = YES;
        
        self.recordingFill.percent = 0;
        [self.recordingFill setNeedsDisplay];
    }
    [self.recordActiveButton setHighlighted:NO];
    
    [self.recordActiveButton setImage:[UIImage imageNamed:@"record_button.png"] forState:UIControlStateNormal];
    
}

-(void)startPlaying{
    [[LocalyticsSession shared] tagEvent:@"Started playing recording"];
    self.playTimerCount = 0;
    self.finishedPanel.hidden = YES;
    self.stopPanel.hidden = NO;
    self.playTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updatePlayLocation)userInfo:nil repeats:YES];
    
    self.player = [[Player alloc] initWithPath:self.recordingInfo.url];
    [self.player play];
    
    self.playing = true;
}
-(void)stopPlaying{
    [[LocalyticsSession shared] tagEvent:@"Stopped playing recording"];
    self.finishedPanel.hidden = NO;
    self.stopPanel.hidden = YES;
    [self.waveform setHighlightPercent:0];
    [self.waveform setNeedsDisplay];
    
    self.recordingFill.percent = 0;
    [self.recordingFill setNeedsDisplay];
    [self.playTimer invalidate];
    self.playTimer = nil;
    
    self.playing = false;
    [self.player stop];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)trashButtonPressed:(id)sender {
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                    message:@"Are you sure you want to delete this recording?"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    self.backPressedLast=NO;
    self.trashPressedLast=YES;
    [alert show];
}
- (IBAction)playButtonPressed:(id)sender {
    [self startPlaying];
}

-(void)homePressed:(id)sender{
    if (!self.finishedPanel.hidden){
        //There is an active recording
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                        message:@"Are you sure you want to delete this recording?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        self.backPressedLast=NO;
        self.trashPressedLast=NO;
        [alert show];
    }
    else{
        [super homePressed:sender];
    }
}

-(void)backPressed:(id)sender{
    
    if (!self.finishedPanel.hidden){
        //There is an active recording
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm Delete"
                                                        message:@"Are you sure you want to delete this recording?"
                                                       delegate:self
                                              cancelButtonTitle:@"Cancel"
                                              otherButtonTitles:@"OK", nil];
        self.backPressedLast=YES;
        self.trashPressedLast=NO;
        [alert show];
    }
    else {
        [super backPressed:sender];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    // the user clicked one of the OK/Cancel buttons
    if (buttonIndex == 1)
    {
        [SharingBundle getCurrentSharingBundle].recordingInfo = nil;
        if (self.trashPressedLast){
            self.waveform.hidden = YES;
            self.finishedPanel.hidden = YES;
            
            self.recordingFill.percent = 0;
            [self.recordingFill setNeedsDisplay];
        }
        else if (self.backPressedLast){
            [super backPressed:self];
            [self dismissViewControllerAnimated:YES completion:^{}];
        }else {
            [super homePressed:nil];
        }
    }
}

- (IBAction)stopButtonPressed:(id)sender {
    [self stopPlaying];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"recordToShare"]){
        SharingBundle* bundle = [SharingBundle getCurrentSharingBundle];
        [bundle setRecordingInfo:self.recordingInfo];
        [bundle setWaveformImage:[self.waveform asImage]];
    }
}
@end
