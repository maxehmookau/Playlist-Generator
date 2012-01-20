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
    [SPSession initializeSharedSessionWithApplicationKey:[NSData dataWithBytes:&g_appkey length:g_appkey_size] userAgent:@"max.playlist2" error:nil];
    [[SPSession sharedSession]attemptLoginWithUserName:username password:password rememberCredentials:NO];
    [[SPSession sharedSession] setDelegate:self];
}

#pragma mark - Spotify Login Delegate
- (void)session:(SPSession *)aSession didFailToLoginWithError:(NSError *)error
{
    UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Failed to Login" message:[error localizedDescription] delegate:self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
    [hud hide:YES];
    [errorAlert show];
}

- (void)sessionDidLoginSuccessfully:(SPSession *)aSession
{
    NSLog(@"Login Successful");
    [hud hide:YES];
    //Create a playback manager
    manager = [[SPPlaybackManager alloc] initWithPlaybackSession:[SPSession sharedSession]];
    [self playTrackAtIndex:3];
}

-(void)playTrackAtIndex:(int)index
{
    NSURL *trackURL = [NSURL URLWithString:@"spotify:track:4BMHp3DkI8VLsuB9Kr0pzu"];
    SPTrack *track = [[SPSession sharedSession] trackForURL:trackURL];
    if (track != nil) {
        
        if (!track.isLoaded) {
            NSLog(@"Try again");
            [self performSelector:@selector(playTrackAtIndex:) withObject:nil afterDelay:0.1];
            return;
        }
        //[artistLabel setText:[[track artists]objectAtIndex:0]];
        [trackLabel setText:[track name]];
        NSError *error = nil;
        if (![manager playTrack:track error:&error]) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Cannot Play Track"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alert show];
        }
        return;
    }
}

#pragma mark - View lifecycle
-(void)viewDidAppear:(BOOL)animated
{
    hud = [[MBProgressHUD alloc] initWithView:self.view];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setLabelText:@"Logging in to Spotify..."];
    [hud show:YES];
    [self loginToSpotifyWithUsername:@"maxehmookau" andPassword:@"fupk5ek2"];
}

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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
