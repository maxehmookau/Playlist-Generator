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
    
    //Background timer
    NSTimer *progressTimer;
    
    //Recorder
    InputRecorder *inputRecorder;
}

-(IBAction)recordButtonPressed:(id)sender;
- (void)timerFireMethod:(NSTimer*)theTimer;
@end
