//
//  AnalysedPlaylistConnection.h
//  Playlist2
//
//  Created by Max Woolf on 01/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysedPlaylistConnection : NSURLConnection
{
    NSString *danceability;
    NSString *energy;
    NSString *tempo;
    NSString *key;
    NSString *mode;
    NSString *results;
}

-(id)initWithDanceability:(NSString *)danceability energy:(NSString *)energy tempo:(NSString *)tempo key:(NSString *)key mode:(NSString *)mode results:(NSString *)results delegate:(id)delegate;
-(NSURLRequest *)getRequest;
@end
