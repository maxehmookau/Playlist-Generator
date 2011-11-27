//
//  AnalysisConnection.m
//  Playlist2
//
//  Created by Max Woolf on 26/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AnalysisConnection.h"
#define API_KEY "BNOAEBT3IZYZI6WXI"

@implementation AnalysisConnection
-(id)initWithRequest:(NSURLRequest *)request delegate:(id)delegate echoprintCode:(NSString *)echoprintCode
{
    code = echoprintCode;
    self = [super initWithRequest:[self getRequest] delegate:delegate];
    return self;
}

-(NSURLRequest *)getRequest
{
    NSString *queryString = [[NSString alloc]initWithFormat:@"http://developer.echonest.com/api/v4/song/identify?api_key=%s&version=4.11&code=%@", API_KEY, code];
    NSLog(@"%@", queryString);
    NSURL *queryURL = [[NSURL alloc] initWithString:queryString];
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:queryURL];
    return request;
}
@end
