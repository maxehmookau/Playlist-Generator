//
//  ExtractSpotifyURI.m
//  Playlist2
//
//  Created by Max Woolf on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ExtractSpotifyURI.h"

@implementation ExtractSpotifyURI

-(id)initWithSpotifyJSONString:(NSString *)input
{
    spotifyJSON = input;
    self = [super init];
    return self;
}

-(NSString *)getURI
{
    parser = [[SBJsonParser alloc] init];
    NSDictionary *rootDictionary = [parser objectWithString:spotifyJSON];
    NSArray *tracks = [rootDictionary objectForKey:@"tracks"];
    NSDictionary *trackOne = [tracks objectAtIndex:0];
    NSString *URI = [trackOne objectForKey:@"href"];
    NSLog(@"%@", URI);
    return URI;
}
@end
