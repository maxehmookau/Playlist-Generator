//
//  IdentifyViewController.h
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "InputRecorder.h"

@interface IdentifyViewController : UIViewController <AVAudioRecorderDelegate>
{
    
    //UI Elements
    IBOutlet UIButton *recordButton;
    IBOutlet UIProgressView *progressView;
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
        //Metering Elements
        IBOutlet UIImageView *meter0;
        IBOutlet UIImageView *meter1;
        IBOutlet UIImageView *meter2;
        IBOutlet UIImageView *meter3;
        IBOutlet UIImageView *meter4;
        NSArray *meterObjects;  
    
    //Background timers
    NSTimer *progressTimer;
    NSTimer *powerTimer;
    
    //Recorder
    InputRecorder *inputRecorder;
    float averageVolume;
}

-(IBAction)recordButtonPressed:(id)sender;
- (void)timerFireMethod:(NSTimer*)theTimer;
@end
