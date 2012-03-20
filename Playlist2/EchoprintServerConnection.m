//
//  EchoprintServerConnection.m
//  Playlist2
//
//  Created by Max Woolf on 19/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EchoprintServerConnection.h"

@implementation EchoprintServerConnection
-(id)initWithCode:(NSString *)aCode delegate:(id)aDelegate
{
    code = aCode;
    return [self initWithRequest:[self getRequest] delegate:aDelegate startImmediately:YES];
}

-(NSURLRequest *)getRequest
{
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:[NSString stringWithFormat: @"http://62.233.104.200:5224/query?version=4.12&code=%@",code ]]];
    NSLog([NSString stringWithFormat: @"http://62.233.104.200:5224/query?version=4.12&code=%@",code]);
    return request;
}

@end
