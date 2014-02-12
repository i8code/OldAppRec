// Copyright (c) 2012 Alex Wiltschko
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
//
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.


#import "NovocaineViewController.h"
#import "S3Helper.h"

@interface NovocaineViewController ()

@property (nonatomic, assign) RingBuffer *ringBuffer;

@end

@implementation NovocaineViewController

- (void)dealloc
{
    delete self.ringBuffer;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    __weak NovocaineViewController * wself = self;
    
    self.ringBuffer = new RingBuffer(32768, 2);
    self.audioManager = [Novocaine audioManager];
    
    
    // Basic playthru example
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
    //        float volume = 0.5;
    //        vDSP_vsmul(data, 1, &volume, data, 1, numFrames*numChannels);
    //        wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    //    }];
    //
    //
    //    [self.audioManager setOutputBlock:^(float *outData, UInt32 numFrames, UInt32 numChannels) {
    //        wself.ringBuffer->FetchInterleavedData(outData, numFrames, numChannels);
    //    }];
    
    
    // MAKE SOME NOOOOO OIIIISSSEEE
    // ==================================================
    //     [self.audioManager setOutputBlock:^(float *newdata, UInt32 numFrames, UInt32 thisNumChannels)
    //         {
    //             for (int i = 0; i < numFrames * thisNumChannels; i++) {
    //                 newdata[i] = (rand() % 100) / 100.0f / 2;
    //         }
    //     }];
    
    
    // MEASURE SOME DECIBELS!
    // ==================================================
    //    __block float dbVal = 0.0;
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels) {
    //
    //        vDSP_vsq(data, 1, data, 1, numFrames*numChannels);
    //        float meanVal = 0.0;
    //        vDSP_meanv(data, 1, &meanVal, numFrames*numChannels);
    //
    //        float one = 1.0;
    //        vDSP_vdbcon(&meanVal, 1, &one, &meanVal, 1, 1, 0);
    //        dbVal = dbVal + 0.2*(meanVal - dbVal);
    //        printf("Decibel level: %f\n", dbVal);
    //
    //    }];
    
    // SIGNAL GENERATOR!
    //    __block float frequency = 2000.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] = sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / frequency);
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    
    
    // DALEK VOICE!
    // (aka Ring Modulator)
    
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         wself.ringBuffer->AddNewInterleavedFloatData(data, numFrames, numChannels);
    //     }];
    //
    //    __block float frequency = 100.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         wself.ringBuffer->FetchInterleavedData(data, numFrames, numChannels);
    //
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] *= sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / frequency);
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    //
    
    // VOICE-MODULATED OSCILLATOR
    
    //    __block float magnitude = 0.0;
    //    [self.audioManager setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //         vDSP_rmsqv(data, 1, &magnitude, numFrames*numChannels);
    //     }];
    //
    //    __block float frequency = 100.0;
    //    __block float phase = 0.0;
    //    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
    //     {
    //
    //         printf("Magnitude: %f\n", magnitude);
    //         float samplingRate = wself.audioManager.samplingRate;
    //         for (int i=0; i < numFrames; ++i)
    //         {
    //             for (int iChannel = 0; iChannel < numChannels; ++iChannel)
    //             {
    //                 float theta = phase * M_PI * 2;
    //                 data[i*numChannels + iChannel] = magnitude*sin(theta);
    //             }
    //             phase += 1.0 / (samplingRate / (frequency));
    //             if (phase > 1.0) phase = -1;
    //         }
    //     }];
    
    
    // AUDIO FILE READING OHHH YEAHHHH
    // ========================================
//    
//    NSArray *pathComponents = [NSArray arrayWithObjects:
//                               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
//                               @"My Recording.m4a",
//                               nil];
//    NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
//    NSLog(@"URL: %@", outputFileURL);
//    
//    NSLog(@"%hhd",[[NSFileManager defaultManager] fileExistsAtPath:[outputFileURL absoluteString]]);
//    
//    self.fileReader = [[AudioFileReader alloc]
//                       initWithAudioFileURL:outputFileURL
//                       samplingRate:self.audioManager.samplingRate
//                       numChannels:self.audioManager.numOutputChannels];
//    
//    [self.fileReader play];
//    self.fileReader.currentTime = 30.0;
//    
//    
//    [self.audioManager setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         [wself.fileReader retrieveFreshAudio:data numFrames:numFrames numChannels:numChannels];
//         NSLog(@"Time: %f", wself.fileReader.currentTime);
//     }];
    
    

    
    
    
    // AUDIO FILE WRITING YEAH!
    // ========================================
        NSArray *pathComponents = [NSArray arrayWithObjects:
                                   [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject],
                                   @"My Recording.m4a",
                                   nil];
        NSURL *outputFileURL = [NSURL fileURLWithPathComponents:pathComponents];
    
//    NSLog(@"%@", [outputFileURL absoluteString]);
//    NSLog(@"%@", [outputFileURL relativePath]);
//    NSLog(@"%@", [outputFileURL relativeString]);
//    
//    NSLog(@"%@", [[NSFileManager defaultManager] fileExistsAtPath:[outputFileURL absoluteString] isDirectory:NO]?@"exists":@"does not exist");
//    NSLog(@"%@", [[NSFileManager defaultManager] fileExistsAtPath:[outputFileURL relativePath] isDirectory:NO]?@"exists":@"does not exist");
//    NSLog(@"%@", [[NSFileManager defaultManager] fileExistsAtPath:[outputFileURL relativeString] isDirectory:NO]?@"exists":@"does not exist");
//    
//    NSData *data = [[NSFileManager defaultManager] contentsAtPath:[outputFileURL relativePath]];
//    
//    [S3Helper saveToS3:data withName:@"jasontest.m4a"];
//    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:outputFileURL
//                                                                   error:nil];
//    player.numberOfLoops = -1; //Infinite
//    
//    [player play];
//    return;
    
    
    
    float* outputBlocks = (float*)malloc(sizeof(float)*450);
    
    
        NSLog(@"URL: %@", outputFileURL);
    
        [self listFileAtPath:[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject]];
    
        self.fileWriter = [[AudioFileWriter alloc]
                           initWithAudioFileURL:outputFileURL
                           samplingRate:self.audioManager.samplingRate
                           numChannels:self.audioManager.numInputChannels];
    
    
        __block int counter = 0;
        self.audioManager.inputBlock = ^(float *data, UInt32 numFrames, UInt32 numChannels) {
            [wself.fileWriter writeNewAudio:data numFrames:numFrames numChannels:numChannels];
            
            float sum = 0;
            for (int y=0;y<numFrames;y++){
                sum+=data[y*numChannels];
            }
            outputBlocks[counter]=fabs(sum);
            counter += 1;
            if (counter > 450) { // roughly 5 seconds of audio
                wself.audioManager.inputBlock = nil;
                [wself.fileWriter pause];
                wself.fileWriter = nil;
                
                NSString* csv = [NSString stringWithFormat:@"%f", outputBlocks[0]];
                for (int i=1;i<450;i++){
                    NSLog(@"%f", outputBlocks[i]);
                    csv = [NSString stringWithFormat:@"%@,%f", csv, outputBlocks[i]];
                }
                
                NSData *data = [[NSFileManager defaultManager] contentsAtPath:[outputFileURL relativePath]];
                //
                [S3Helper saveToS3:data withName:@"jasontest.m4a"];
                
                data = [csv dataUsingEncoding:NSUTF8StringEncoding];
                [S3Helper saveToS3:data withName:@"waveform.csv"];
                data=nil;
                NSString* download = [[NSString alloc] initWithData:[S3Helper fileFromS3WithName:@"waveform.csv"]
                                                           encoding:NSUTF8StringEncoding];
                NSLog(@"%@", download);
            }
        };
    

    
    // START IT UP YO
    [self.audioManager play];
    
}

-(NSArray *)listFileAtPath:(NSString *)path
{
    //-----> LIST ALL FILES <-----//
    NSLog(@"LISTING ALL FILES FOUND");
    
    int count;
    
    NSArray *directoryContent = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:path error:NULL];
    for (count = 0; count < (int)[directoryContent count]; count++)
    {
        NSLog(@"File %d: %@", (count + 1), [directoryContent objectAtIndex:count]);
    }
    return directoryContent;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

@end