//
//  AnalysedPlaylistConnection.m
//  Playlist2
//
//  Created by Max Woolf on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AnalysedPlaylistConnection.h"

@implementation AnalysedPlaylistConnection
-(id)initWithDanceability:(NSString *)danceability energy:(NSString *)energy tempo:(NSString *)tempo key:(NSString *)key mode:(NSString *)mode results:(NSString *)results delegate:(id)delegate 
{
    
    self->danceability = danceability;
    self->energy = energy;
    self->tempo = tempo;
    self->key = key;
    self->mode = mode;
    self->results = results;
    return [self initWithRequest:[self getRequest] delegate:delegate];
}

-(NSURLRequest *)getRequest
{
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://developer.echonest.com/api/v4/playlist/static?api_key=BNOAEBT3IZYZI6WXI&type=artist-description&description=pop&results=%@&max_danceability=%@&max_energy=%@&max_tempo=%@&key=%@&mode=%@", results, danceability, energy, tempo, key, mode]];
    NSLog(@"%@", [url absoluteString]);
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:url];
    return request;
}
@end
