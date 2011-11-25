//
//  IdentifyViewController.m
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "IdentifyViewController.h"
#import "OptionsViewController.h"

@implementation IdentifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}


#pragma mark - Pressing record button
-(IBAction)recordButtonPressed:(id)sender
{
    //Begin counter
    progressTimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
    
    //Alter UI elements
    [recordButton setTitle:@"Recording..." forState:UIControlStateNormal];
    
    //Begin Recording - Don't need any parameters, this is all done for us.
    inputRecorder = [[InputRecorder alloc] initWithURL:nil settings:nil error:nil];
    [inputRecorder setDelegate:self];
    [inputRecorder record];
    
}

- (void)timerFireMethod:(NSTimer *)theTimer
{
    if([progressView progress] != 1.0)
    {
        [progressView setProgress:[progressView progress] + 0.05];
    }else{
        [inputRecorder stop];
        [recordButton setTitle:@"Working" forState:UIControlStateNormal];
        [progressView setHidden:YES];
        [activityIndicator startAnimating];
    }
}

-(void)audioRecorderDidFinishRecording:(AVAudioRecorder *)recorder successfully:(BOOL)flag
{
    if(flag)
    {
        NSLog(@"Successful");
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
