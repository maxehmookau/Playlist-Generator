//
//  SpotifyURILookup.m
//  This class takes the name of a track and artist and finds
//  a list of tracks on the spotify library. 
//
//  Created by Max Woolf on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SpotifyURILookup.h"

@implementation SpotifyURILookup
//Create a new SpotifyURILookup object.
//Assign a track and artist name.
-(id)initWithTrackName:(NSString *)track artistName:(NSString *)artist delegate:(id)delegate
{
    artistName = artist;
    trackName = track;
    self = [super initWithRequest:[self getSpotifyURIRequest] delegate:delegate];
    return self;
}

-(NSURLRequest *)getSpotifyURIRequest
{
    NSString *requestString = [[[NSString alloc] initWithFormat:@"http://ws.spotify.com/search/1/track.json?q=artist:%@ AND track:%@", artistName, trackName] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@", requestString);
    NSURL *requestURL = [[NSURL alloc] initWithString:requestString];
    return [[NSURLRequest alloc] initWithURL:requestURL];
}
@end
