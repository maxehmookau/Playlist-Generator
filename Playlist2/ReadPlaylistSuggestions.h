//
//  ReadPlaylistSuggestions.h
//  Playlist2
//
//  Created by Max Woolf on 16/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBJson.h"

@interface ReadPlaylistSuggestions : NSObject
{
    NSData *jsonData;
    NSString *jsonString;
    NSDictionary *jsonRootDictionary;
    SBJsonParser *parser;
}

//Initialise
-(id)initWithJsonData:(NSData *) data;
-(int)calculateNumberOfSongs;
-(NSMutableArray *)getArtistList;
-(NSMutableArray *)getTrackList;
-(NSArray *)getSongsArray;
@end
