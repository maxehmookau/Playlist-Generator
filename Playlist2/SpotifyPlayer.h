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

@interface SpotifyPlayer : UIViewController <SPSessionDelegate>
{
    //UI Elements
    IBOutlet UILabel *trackLabel;
    IBOutlet UILabel *artistLabel;
    IBOutlet UIImageView *coverImageView;
    IBOutlet UIButton *playPauseButton;
    MBProgressHUD *hud;
    
    //Model Variables
    NSArray *trackURIs;
    int currentTrackPlayingIndex;
    SPPlaybackManager *manager;
}

-(void)setArray:(NSArray *)theArray;
-(void)loginToSpotifyWithUsername:(NSString *)username andPassword:(NSString *)password;
-(void)playTrackAtIndex:(int)index;
-(void)getCoverImageForTrack:(SPTrack *)track;
@end
