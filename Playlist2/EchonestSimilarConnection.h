//
//  EchonestSimilarConnection.h
//  Playlist2
//
//  Created by Max Woolf on 11/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EchonestSimilarConnection : NSURLConnection
{
    NSString *trackID;
    int noOfTracks;
    float danceability;
    float variety;
}

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate trackID:(NSString *)inputID danceability:(float)danceValue variety:(float)varietyValue numberOfTracks:(int)playlistSize;

-(NSURLRequest *)getRequest;
@end
