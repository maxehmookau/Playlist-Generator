//
//  SpotifyPlayer.m
//  Playlist2
//
//  Created by Max Woolf on 20/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SpotifyPlayer.h"
#import "CocoaLibSpotify.h"
#import "appkey.h"
#import "playlist2AppDelegate.h"

@implementation SpotifyPlayer

-(id)initWithUserName:(NSString *)aUsername password:(NSString *)aPassword
{
    spotifyUsername = aUsername;
    spotifyPassword = aPassword;
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

-(void)setArray:(NSArray *)theArray
{
    if(trackURIs != theArray)
    {
        trackURIs = theArray;
    }
}

-(void)loginToSpotifyWithUsername:(NSString *)username andPassword:(NSString *)password
{
    NSError* error  = nil;
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:@"Logging in to Spotify..."];
    [hud show:YES];
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"com.maxwoolf.ionia" error:&error];
    
    if(username == nil && password == nil)
    {
        [[SPSession sharedSession]attemptLoginWithStoredCredentials:&error];
    }else{
        [[SPSession sharedSession]attemptLoginWithUserName:username password:password rememberCredentials:YES];
    }
    
    [[SPSession sharedSession] setDelegate:self];
    [[SPSession sharedSession] setPlaybackDelegate:self];
    if(error)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:[error localizedDescription] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [errorAlert show];
    }
}

#pragma mark - Spotify Delegate
- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    [hud hide:YES];
    if([error code] == 6)
    {
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Invalid Username!" message:@"WAH WAH Oops." delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [errorAlert show];
    }else{
        UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Failed to Login" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [errorAlert show];
        [SPSession sharedSession];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}

-(void)sessionDidLogOut:(SPSession *)aSession
{
    [hud hide:YES];
    [self displayCurrentSpotifyStatusForSession:aSession];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"Login Successful");
    
    [hud setLabelText:@"Loading track"];
    //Create a playback manager
    manager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [self playTrackAtIndex:0];
}

- (void)sessionDidLosePlayToken:(SPSession *)aSession
{
    [SPSession sharedSession].playing = NO;
    //[playPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
    UIAlertView *loseTokenAlert = [[UIAlertView alloc] initWithTitle:@"Sorry" message:@"Playback was paused because this account was logged in elsewhere" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [loseTokenAlert show];
}

- (void)sessionDidEndPlayback:(SPSession *)aSession
{
    [self nextTrack:nil];
}

- (void)session:(SPSession *)aSession didEncounterStreamingError:(NSError *)error
{
    UIAlertView *streamingErrorAlert = [[UIAlertView alloc] initWithTitle:@"Awww... crap." message:@"Streaming error, this isn't going to work..." delegate:self cancelButtonTitle:@"Alright" otherButtonTitles:nil];
    [streamingErrorAlert show];
}

#pragma mark - Controls
//Called to play the track at index in the preloaded array of Spotify URIs.
//index should already be validated before this is called or it will throw an out of bounds exception.
-(void)playTrackAtIndex:(NSNumber *)index
{
    NSURL *trackURL = [NSURL URLWithString:[trackURIs objectAtIndex:[index intValue]]];
    SPTrack *track = [[SPSession sharedSession] trackForURL:trackURL];
    if (track != nil) {
        
        if (!track.isLoaded) {
            NSLog(@"Still waiting for metadata to load... trying again.");
            [self performSelector:@selector(playTrackAtIndex:) withObject:index afterDelay:0.1];
            return;
        }
        
        //Set metadata
        SPArtist *currentArtist = [[track artists]objectAtIndex:0]; //Just get the first artist, there might be a few
        
        NSString *artistName = [[NSString alloc] initWithString:currentArtist.name];
        [artistLabel setText:artistName];
        [trackLabel setText:[track name]];
        
        nowPlayingInfo = [[NSMutableDictionary alloc] init];
        [nowPlayingInfo setValue:artistName forKey:MPMediaItemPropertyAlbumArtist];
        [nowPlayingInfo setValue:[track name] forKey:MPMediaItemPropertyTitle];
        
        [self getCoverImageForTrack:track];
        
        NSError *error = nil;
        if (![manager playTrack:track error:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        
        
        [hud hide:YES afterDelay:1];
        currentTrackPlayingIndex = [index intValue];
        currentTrackDuration = [track duration];
        [progressMeter setMaximumValue:currentTrackDuration];

        timer = [NSTimer timerWithTimeInterval:1 target:self selector:@selector(timerFireMethod:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop]addTimer:timer forMode:NSDefaultRunLoopMode];
        return;
    }
}

- (void)timerFireMethod:(NSTimer*)theTimer
{
    [progressMeter setValue:[progressMeter value]+1];
}

-(IBAction)togglePlayPause:(id)sender
{
    if(manager.isPlaying)
    {
        [SPSession sharedSession].playing = NO;
        [playPauseButton setImage:[UIImage imageNamed:@"play.png"]];
         }else{
        [SPSession sharedSession].playing = YES;
        [playPauseButton setImage:[UIImage imageNamed:@"pause.png"]];
    }
}

-(IBAction)movedSlider:(id)sender;
{
    NSLog(@"%f", [progressMeter value]);
    [manager seekToTrackPosition:[progressMeter value]];
}

-(IBAction)nextTrack:(id)sender
{
    if(currentTrackPlayingIndex < [trackURIs count]-1)
    {
        [hud setLabelText:@"Loading"];
        [hud show:YES];
        [progressMeter setValue:0];
        [timer invalidate];
        [self playTrackAtIndex: [NSNumber numberWithInt:currentTrackPlayingIndex+1]];
    }
}

-(IBAction)previousTrack:(id)sender
{
    //Make sure you don't overshoot the array
    if(!currentTrackPlayingIndex == 0)
    {
        [hud setLabelText:@"Loading"];
        [hud show:YES];
        [progressMeter setValue:0];
        [timer invalidate];
        [self playTrackAtIndex:[NSNumber numberWithInt:currentTrackPlayingIndex-1]];
    }
}

-(void)getCoverImageForTrack:(SPTrack *)track
{
    SPAlbum *currentAlbum = [track album]; 
    SPImage *coverSPImage = [currentAlbum cover];
    [coverSPImage beginLoading];
    
    if (!coverSPImage.loaded) {
        NSLog(@"Still waiting for image to load... trying again.");
        [self performSelector:@selector(getCoverImageForTrack:) withObject:track afterDelay:0.1];
        return;
    }
    
    UIImage *coverImage = [coverSPImage image];
    [nowPlayingInfo setValue:[[MPMediaItemArtwork alloc]initWithImage:coverImage] forKey:MPMediaItemPropertyArtwork];
    [nowPlaying setNowPlayingInfo:nowPlayingInfo];
    [coverImageView setImage:coverImage];
}



-(void) initAudioSession 
{
    // Registers this class as the delegate of the audio session to listen for audio interruptions
    [[AVAudioSession sharedInstance] setDelegate: self];
    //Set the audio category of this app to playback.
    NSError *setCategoryError = nil; [[AVAudioSession sharedInstance]
                                      setCategory: AVAudioSessionCategoryPlayback error: &setCategoryError];

    
    //Activate the audio session
    NSError *activationError = nil;
    [[AVAudioSession sharedInstance] setActive: YES error: &activationError];

}

- (void) remoteControlReceivedWithEvent: (UIEvent *) receivedEvent {
    if (receivedEvent.type == UIEventTypeRemoteControl) {
        switch (receivedEvent.subtype) {
            case UIEventSubtypeRemoteControlTogglePlayPause: {
                [self togglePlayPause:self];
                break;
            }
                
            case UIEventSubtypeRemoteControlNextTrack: {
                [self nextTrack:self];
                break;
            }
                
            case UIEventSubtypeRemoteControlPreviousTrack: {
                [self previousTrack:self];
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    [[UIApplication sharedApplication] beginReceivingRemoteControlEvents];
    [self becomeFirstResponder];
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [self loginToSpotifyWithUsername:spotifyUsername andPassword:spotifyPassword];
}

-(void) displayCurrentSpotifyStatusForSession:(SPSession *)aSession
{
    sp_connectionstate state = [[SPSession sharedSession]connectionState];
    
    switch (state) {
        case SP_CONNECTION_STATE_DISCONNECTED:
            NSLog(@"Connection was connected, now disconnected.");
            break;
            
        case SP_CONNECTION_STATE_LOGGED_IN:
            NSLog(@"Currently Logged In");
            break;
            
        case SP_CONNECTION_STATE_LOGGED_OUT:
            NSLog(@"User Not Logged In");
            break;
            
        case SP_CONNECTION_STATE_OFFLINE:
            NSLog(@"Logged in - Offline Mode");
            break;
            
        case SP_CONNECTION_STATE_UNDEFINED:
            NSLog(@"Undefined Error");
            break;
            
        default:
            break;
    }
}

-(void)goHome
{
    [hud setLabelText:@"Logging Out"];
    [hud show:YES];
    
    manager.isPlaying = NO;
    [[SPSession sharedSession]logout];
}


- (void)viewDidLoad
{
    UIBarButtonItem *homeButton = [[UIBarButtonItem alloc] initWithTitle:@"Home" style:UIBarButtonItemStyleBordered target:self action:@selector(goHome)];
                             
                             self.navigationItem.hidesBackButton = YES;
                             self.navigationItem.leftBarButtonItem = homeButton;
    
    //[bottomToolbar setFrame:CGRectMake(0, 375, 320, 85)];
    //[self.navigationController setNavigationBarHidden:YES];
    //[[UIApplication sharedApplication]setStatusBarStyle:UIStatusBarStyleBlackOpaque animated:YES];
    nowPlaying = [MPNowPlayingInfoCenter defaultCenter];
              
    [self initAudioSession];
    currentTrackPlayingIndex = 0;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
}
- (BOOL) canBecomeFirstResponder {
    return YES;
}

- (void)viewDidUnload
{
    [[UIApplication sharedApplication] endReceivingRemoteControlEvents];
    [self resignFirstResponder];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
