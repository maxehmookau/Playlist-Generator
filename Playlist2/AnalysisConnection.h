//
//  AnalysisConnection.h
//  Playlist2
//
//  Created by Max Woolf on 26/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AnalysisConnection : NSURLConnection
{
    NSString *code;
}

-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate echoprintCode:(NSString *)echoprintCode;
-(NSURLRequest *)getRequest;
@end
