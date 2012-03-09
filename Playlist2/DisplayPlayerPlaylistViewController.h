//
//  DisplayPlayerPlaylistViewController.h
//  Playlist2
//
//  Created by Max Woolf on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CocoaLibSpotify.h"

@interface DisplayPlayerPlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSArray *trackURIs;
    NSMutableArray *tracks;
}

/**
 * @function
 * @param trackArray An array of tracks
 */
-(id)initWithTracks:(NSArray *)trackArray;
-(SPTrack *)convertURIToTrack:(NSString *)aURI;
@end
