//
//  ReadPlaylistSuggestions.m
//  Playlist2
//
//  Created by Max Woolf on 16/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "ReadPlaylistSuggestions.h"

@implementation ReadPlaylistSuggestions

-(id)initWithJsonData:(NSData *) data
{
    jsonData = data;
    jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    parser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSLog(@"%@", jsonString);
    
    //jsonRootDictionary holds all json data as parsed dictionary now
    jsonRootDictionary = [parser objectWithString:jsonString error:&error];
    
    //Return object
    self = [super init];
    return self;
}

-(int)calculateNumberOfSongs
{
    return [[self getSongsArray] count];
}

-(NSArray *)getSongsArray
{
    NSDictionary *response = [jsonRootDictionary objectForKey:@"response"];
    return [response objectForKey:@"songs"];
}

-(NSMutableArray *)getArtistList
{
    NSMutableArray *artistList = [[NSMutableArray alloc] initWithCapacity:[self calculateNumberOfSongs]];
    
    //For each element in the array, add the artist
    for(int x = 0; x < [self calculateNumberOfSongs]; x++)
    {
        NSDictionary *currentSong = [[self getSongsArray] objectAtIndex:x];
        [artistList addObject:[currentSong objectForKey:@"artist_name"]];
    }
    return artistList;
}

-(NSMutableArray *)getTrackList
{
    NSMutableArray *trackList = [[NSMutableArray alloc] initWithCapacity:[self calculateNumberOfSongs]];
    
    //For each element in the array, add the artist
    for(int x = 0; x < [self calculateNumberOfSongs]; x++)
    {
        NSDictionary *currentSong = [[self getSongsArray] objectAtIndex:x];
        [trackList addObject:[currentSong objectForKey:@"title"]];
    }
    return trackList;
}
@end
