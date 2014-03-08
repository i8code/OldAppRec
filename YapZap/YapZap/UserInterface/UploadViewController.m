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
@property int uploadedTime;
@property (nonatomic, strong) NSTimer* timer;
@property (nonatomic) BOOL uploadComplete;
@property (nonatomic, strong) Recording* uploadedRecording;
@property (nonatomic, strong) NSString* tagName;

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
    self.uploadedTime=0;
    self.progressBar.progress=0;
    self.doneLabel.hidden = YES;
    self.uploadComplete = NO;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(updateProgress)userInfo:nil repeats:YES];
    [self upload];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.backButton.hidden=YES;
    self.homeButton.hidden = YES;
    self.settingsButton.hidden = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self dismissViewControllerAnimated:YES completion:^{}];
}

-(void)showError{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error uploading the tag. Please try again later" delegate:self cancelButtonTitle:@"ok" otherButtonTitles: nil];
    [alert show];
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
        NSData* jsonBody = [NSJSONSerialization dataWithJSONObject:recordingToCreate.toJSON options:0 error:nil];
//        NSString *jsonString = [[NSString alloc] initWithData:jsonBody encoding:NSUTF8StringEncoding];
//        NSLog(@"%@", jsonString);
        NSString* recordingURL;
        if ([bundle comment]){
            recordingURL = [NSString stringWithFormat:@"/recordings/%@/recordings", recordingToCreate.parentName];
        }
        else {
            self.tagName = [recordingToCreate.parentName lowercaseString];
            recordingURL = [NSString stringWithFormat:@"/tags/%@/recordings", self.tagName];
        }
        NSString* recordingResponse = [RestHelper post:recordingURL withBody:jsonBody andQuery:nil];
        if (!recordingResponse){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self showError];
            });
            return;
        }
        NSDictionary* jsonResponse = [NSJSONSerialization JSONObjectWithData:[recordingResponse dataUsingEncoding:NSUTF8StringEncoding] options:0 error:nil];
        self.uploadedRecording = [Recording fromJSON:jsonResponse];
        
        //Now share on FB/Twitter
        
        
        self.uploadComplete = YES;
    });
    /*dispatch_async(dispatch_get_main_queue(), ^{
        for (int i=0;i<1000;i++){
            if (self.uploadComplete){
                //More here
                return;
            }
            
            [NSThread sleepForTimeInterval:0.1];
            [self.progressBar setProgress:i/10.0];
        }
    });*/
}

-(void) updateProgress{
    self.count++;
    if (self.uploadComplete && self.uploadedTime+10<self.count){
        //Done, done
        [self.timer invalidate];
        self.timer = nil;
        [SharingBundle clear];
        [self dismissViewControllerAnimated:YES completion:^{}];
        
        [self.parent gotoTagWithName:self.tagName];
    }
    else if (self.uploadComplete &&!self.uploadedTime){
        self.doneLabel.hidden = NO;
        self.uploadedTime = self.count;
    }
    else if (self.count>1000){
        [self showError];
        [SharingBundle clear];
        [self.timer invalidate];
        self.timer = nil;
    }
    if (!self.uploadComplete){
        [self.progressBar setProgress:self.count/100.0];
    }
    else {
        [self.progressBar setProgress:1];
    }
    
}

@end
