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
#import "AddToPlaylistViewController.h"

@implementation SpotifyPlayer

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
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
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:@"Logging in to Spotify..."];
    [hud show:YES];
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"max.playlist2" error:nil];
    [[SPSession sharedSession]attemptLoginWithUserName:username password:password rememberCredentials:NO];
    [[SPSession sharedSession] setDelegate:self];
    [[SPSession sharedSession] setPlaybackDelegate:self];
}

#pragma mark - Spotify Delegate
- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Failed to Login" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [hud hide:YES];
    [errorAlert show];
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
    [coverImageView setImage:coverImage];
}

#pragma mark - Action Sheet
-(void)showActionSheet:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"Options" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Add Track to Spotify Playlist", nil];
    [actionSheet showFromToolbar:bottomToolbar];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)
    {
        AddToPlaylistViewController *playlistController = [[AddToPlaylistViewController alloc] initWithURI:[trackURIs objectAtIndex:currentTrackPlayingIndex]];
        [self presentModalViewController:playlistController animated:YES];
    }
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    hud = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:hud];
    [self loginToSpotifyWithUsername:@"maxehmookau" andPassword:@"fupk5ek2"];
}

- (void)viewDidLoad
{
    currentTrackPlayingIndex = 0;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
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
