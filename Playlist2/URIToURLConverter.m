//
//  URIToURLConverter.m
//  Playlist2
//
//  Created by Max Woolf on 18/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "URIToURLConverter.h"

@implementation URIToURLConverter
-(id)initWithSpotifyURI:(NSString *)URI
{
    self->URI = URI;
    self = [super init];
    return self;
}

-(NSString *)convertToURL
{
    NSString *baseURL = [[NSString alloc] initWithString:@"http://open.spotify.com/track/"];
    NSString *trackCode = [[URI componentsSeparatedByString:@":"]objectAtIndex:2];
    
    return [baseURL stringByAppendingString:trackCode];
}
@end
