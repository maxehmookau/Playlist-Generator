//
//  LocalEchoprintConnection.m
//  Playlist2
//
//  Created by Max Woolf on 18/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LocalEchoprintConnection.h"

@implementation LocalEchoprintConnection
-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate echoprintCode:(NSString *)echoprintCode
{
    code = echoprintCode;
    self = [super initWithRequest:[self getRequest] delegate:delegate];
    return self;
}

-(NSURLRequest *)getRequest
{
    NSString *queryString = [[NSString alloc]initWithFormat:@"http://192.168.0.9:37760/query?version=4.12&code=%@", code];
    NSLog(@"%@", queryString);
    NSURL *queryURL = [[NSURL alloc] initWithString:queryString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:queryURL];
    return request;
}
@end
