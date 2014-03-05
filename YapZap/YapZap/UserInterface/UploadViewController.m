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

@interface UploadViewController ()

@property int count;
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
    self.progressBar.progress=0;
    self.doneLabel.hidden = YES;
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress)userInfo:nil repeats:YES];
    [self upload];
}

-(void)viewWillAppear:(BOOL)animated{
    self.backButton.hidden=YES;
    self.parent.homeButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        NSData* jsonBody = [NSJSONSerialization dataWithJSONObject:recordingToCreate options:0 error:nil];
        NSString* recordingURL;
        if ([bundle comment]){
            recordingURL = [NSString stringWithFormat:@"/recordings/%@", recordingToCreate.parentName];
        }
        else {
            recordingURL = [NSString stringWithFormat:@"/tags/%@", recordingToCreate.parentName];
        }
        NSString* recordingResponse = [RestHelper post:recordingURL withBody:jsonBody andQuery:nil];
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:[recordingResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.uploadedRecording = [Recording fromJSON:jsonResponse];
        
        //Now share on FB/Twitter
        
        
        self.uploadComplete = YES;
    });
    dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0;i<1000;i++){
            if (self.uploadComplete){
                //More here
                return;
            }
            
            [NSThread sleepForTimeInterval:0.1];
            [self.progressBar setProgress:i/10.0];
        }
    });
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
        
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
}

@end
