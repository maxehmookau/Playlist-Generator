//
//  SpotifyPlayer.h
//  Playlist2
//
//  Created by Max Woolf on 20/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CocoaLibSpotify.h"
#import "SPPlaybackManager.h"

@interface SpotifyPlayer : UIViewController <SPSessionDelegate, SPSessionPlaybackDelegate, UIActionSheetDelegate>
{
    //UI Elements
    IBOutlet UIBarButtonItem *playPauseButton;
    IBOutlet UILabel *trackLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UIImageView *coverImageView;
    IBOutlet UISlider *progressMeter;
    IBOutlet UIToolbar *bottomToolbar;
    MBProgressHUD *hud;
    
    //Model Variables
    NSArray *trackURIs;
    int currentTrackPlayingIndex;
    SPPlaybackManager *manager;
    NSTimeInterval currentTrackDuration;
    NSTimer *timer;
}

-(void)setArray:(NSArray *)theArray;
-(void)loginToSpotifyWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)playTrackAtIndex:(NSNumber *)index;
-(void)getCoverImageForTrack:(SPTrack *)track;
-(void)timerFireMethod:(NSTimer*)theTimer;

-(IBAction)togglePlayPause:(id)sender;
-(IBAction)nextTrack:(id)sender;
-(IBAction)previousTrack:(id)sender;
-(IBAction)movedSlider:(id)sender;
-(IBAction)showActionSheet:(id)sender;

@end
