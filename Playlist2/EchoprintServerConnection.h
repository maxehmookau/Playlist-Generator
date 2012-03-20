//
//  EchoprintServerConnection.h
//  Playlist2
//
//  Created by Max Woolf on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EchoprintServerConnection : NSURLConnection
{
    NSString *code;
}

-(id)initWithCode:(NSString *)aCode delegate:(id)aDelegate;
-(NSURLRequest *)getRequest;
@end
