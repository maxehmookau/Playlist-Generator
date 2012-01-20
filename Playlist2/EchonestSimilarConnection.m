//
//  EchonestSimilarConnection.m
//  Playlist2
//
//  Created by Max Woolf on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EchonestSimilarConnection.h"
#define API_KEY "BNOAEBT3IZYZI6WXI"

@implementation EchonestSimilarConnection
-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate trackID:(NSString *)inputID danceability:(float)danceValue variety:(float)varietyValue numberOfTracks:(int)playlistSize
{
    trackID = inputID;
    danceability = danceValue;
    variety = varietyValue;
    noOfTracks = (int)playlistSize;
    
    self = [super initWithRequest:[self getRequest] delegate:delegate];
    return self;
}


-(NSURLRequest *)getRequest
{
    float min_danceability = 0.0;
    if(danceability > 0.4)
    {
        min_danceability = danceability - 0.39;
    }else{
        min_danceability = 0;
    }
    #warning - Debug ON!
    NSString *queryString = [[NSString alloc]initWithFormat:@"http://developer.echonest.com/api/v4/playlist/static?api_key=%s&type=song-radio&variety=%f&max_danceability=%f&min_danceability=%f&results=%i&song_id=SOLGISP128CB7B06E3", API_KEY, variety, danceability, min_danceability,noOfTracks];
    
//        queryString = [[NSString alloc]initWithFormat:@"http://developer.echonest.com/api/v4/playlist/static?api_key=%s&type=song-radio&variety=%f&max_danceability=%f&results=%i&song_id=%@", API_KEY, variety,danceability,noOfTracks,trackID];
    
    
    NSLog(@"%@", queryString);
    NSURL *queryURL = [[NSURL alloc] initWithString:queryString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:queryURL];
    return request;
}
@end
