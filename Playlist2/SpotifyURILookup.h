//
//  SpotifyURILookup.h
//  Playlist2
//
//  Created by Max Woolf on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SpotifyURILookup : NSURLConnection
{
    //Input Values
    NSString *artistName;
    NSString *trackName;
    
    //Connections
    NSURLConnection *spotifyConnection;
}

//Methods
//Override initialisation method with just the bits we need
-(id)initWithTrackName:(NSString *)track artistName:(NSString *)artist delegate:(id)delegate;

//Package up GET request
-(NSURLRequest *)getSpotifyURIRequest;


@end
