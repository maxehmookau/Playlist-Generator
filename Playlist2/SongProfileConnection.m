//
//  SongProfileConnection.m
//  Playlist2
//
//  Created by Max Woolf on 26/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "SongProfileConnection.h"
#define API_KEY "BNOAEBT3IZYZI6WXI"

@implementation SongProfileConnection


-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate trackID:(NSString *)ID
{
    trackID = ID;
    self = [super initWithRequest:[self getRequest] delegate:delegate];
    return self;
}


-(NSURLRequest *)getRequest
{
    NSString *queryString = [[NSString alloc]initWithFormat:@"http://developer.echonest.com/api/v4/song/profile?api_key=%s&format=json&id=%@", API_KEY, trackID];
    NSLog(@"%@", queryString);
    NSURL *queryURL = [[NSURL alloc] initWithString:queryString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:queryURL];
    return request;
}
@end
