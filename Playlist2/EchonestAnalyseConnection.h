//
//  EchonestAnalyseConnection.h
//  Playlist2
//
//  Created by Max Woolf on 31/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EchonestAnalyseConnection : NSURLConnection
{
    NSString *url;
    CFURLRef destRef;
}
-(id)initWithFileURL:(NSString *)theUrl delegate:(id)delegate;
-(NSURLRequest *)getRequest;
-(void)convertToMP4;
-(NSURL *)getFilePath;
@end
