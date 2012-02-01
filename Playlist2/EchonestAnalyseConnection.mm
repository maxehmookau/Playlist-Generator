//
//  EchonestAnalyseConnection.m
//  Playlist2
//
//  Created by Max Woolf on 31/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EchonestAnalyseConnection.h"
#import "AVFoundation/AVFoundation.h"


@implementation EchonestAnalyseConnection

-(id)initWithFileURL:(NSString *)theUrl delegate:(id)delegate
{
    url = theUrl;
    return [self initWithRequest:[self getRequest] delegate:delegate];
}

-(void)convertToMP4
{
    //AVAsset *inputAudio = [AVAsset assetWithURL:[NSURL URLWithString:url]];
    //AVAssetReader *reader = [[AVAssetReader alloc] initWithAsset:inputAudio error:nil];
    
    //AVAssetWriter *writer = [[AVAssetWriter alloc] initWithURL:[self getFilePath] fileType:AVFileTypeAppleM4A error:nil];
  //  AVAssetWriterInput *inputWriter = [[AVAssetWriterInput alloc] initWithMediaType:AVFileTypeAppleM4A outputSettings:];
    //[inputWriter appendSampleBuffer:];
    //[writer addInput:inputWriter];
}

-(NSURL *)getFilePath
{
    NSArray *dirPaths;
    NSString *docsDir;
    dirPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);    
    docsDir = [dirPaths objectAtIndex:0];
    NSString *soundFilePath = [docsDir stringByAppendingPathComponent:@"sound.wav"];
    NSURL *newURL = [[NSURL alloc] initFileURLWithPath:soundFilePath];
    return newURL;
}

-(NSMutableURLRequest *)getRequest
{
    [self convertToMP4];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://developer.echonest.com/api/v4/track/upload?api_key=BNOAEBT3IZYZI6WXI&filetype=wav&wait=true&bucket=audio_summary"]];
    
    [request setValue:@"application/octet-stream" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPMethod:@"POST"];
    NSData *audioData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:url]];
    [request setHTTPBody:audioData];
    return request;
}
@end
