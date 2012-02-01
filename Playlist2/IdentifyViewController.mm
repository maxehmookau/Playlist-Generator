//
//  IdentifyViewController.m
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IdentifyViewController.h"
#import "AnalyseViewController.h"

@implementation IdentifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
         self.title = @"Recording";
    }
    return self;
}


#pragma mark - Pressing record button
-(IBAction)recordButtonPressed:(id)sender
{
    //Begin counter
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    powerTimer = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    //Alter UI elements
    [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    [recordButton setEnabled:NO];
    
    //Begin Recording - Don't need any parameters, this is all done for us.
    inputRecorder = [[InputRecorder alloc] initWithURL:nil settings:nil error:nil];
    [inputRecorder setDelegate:self];
    [inputRecorder setMeteringEnabled:YES];
    [inputRecorder record];
    
}

- (void)timerFireMethod:(NSTimer *)theTimer
{
    if(theTimer == progressTimer)
    {
        if([progressView progress] != 1.0)
        {
            [progressView setProgress:[progressView progress] + 0.0025];
        }else{
            //Stop everything
            [inputRecorder stop];
            [progressTimer invalidate];
            [powerTimer invalidate];
            
            
            [recordButton setTitle:@"Working" forState:UIControlStateNormal];
            [progressView setHidden:YES];
            [activityIndicator startAnimating];
        }
    }else if(theTimer == powerTimer)
    {
        [inputRecorder updateMeters];
        averageVolume = [inputRecorder averagePowerForChannel:0];
        //Set all values to 0
        for(int x = 0; x < [meterObjects count]; x++)
        {
            [[meterObjects objectAtIndex:x]setHidden:YES];
        }
        
        if(averageVolume > -5)
        {
            [[meterObjects objectAtIndex:4]setHidden:NO];
        }
        if(averageVolume > -15)
        {
            [[meterObjects objectAtIndex:4]setHidden:NO];
        }
        if(averageVolume > -25)
        {
            [[meterObjects objectAtIndex:3]setHidden:NO];
        }
        if(averageVolume > -35)
        {
            [[meterObjects objectAtIndex:2]setHidden:NO];
        }
        if(averageVolume > -45)
        {
            [[meterObjects objectAtIndex:1]setHidden:NO];
        }
        if(averageVolume > -55)
        {
            [[meterObjects objectAtIndex:0]setHidden:NO];
        }
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if(flag)
    {
        NSLog(@"Successful");
        AnalyseViewController *nextVC = [[AnalyseViewController alloc] init];
        nextVC.recordingURL = inputRecorder.url;
        [self.navigationController pushViewController:nextVC animated:YES];
        [activityIndicator stopAnimating];
    }else{
        NSLog(@"Not successful");
    }
}

#pragma mark - Built in methods

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    meterObjects = [[NSArray alloc] initWithObjects:meter0, meter1, meter2, meter3, meter4, nil];
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated
{
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
