//
//  LocalEchoprintConnection.h
//  Playlist2
//
//  Created by Max Woolf on 18/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LocalEchoprintConnection : NSURLConnection
{
    NSString *code;
}

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate echoprintCode:(NSString *)echoprintCode;
-(NSURLRequest *)getRequest;
@end
