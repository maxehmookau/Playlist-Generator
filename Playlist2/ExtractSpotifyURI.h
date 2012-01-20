//
//  ExtractSpotifyURI.h
//  Playlist2
//
//  Created by Max Woolf on 17/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface ExtractSpotifyURI : NSObject
{
    NSString *spotifyJSON;
    SBJsonParser *parser;
}


-(id)initWithSpotifyJSONString:(NSString *)input;
-(NSString *)getURI;
@end
