//
//  URIToURLConverter.h
//  Playlist2
//
//  Created by Max Woolf on 18/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface URIToURLConverter : NSObject
{
    NSString *URI;
}

-(id)initWithSpotifyURI:(NSString *)URI;
-(NSString *)convertToURL;
@end
