//
//  InputRecorder.h
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>

@interface InputRecorder : AVAudioRecorder
-(NSDictionary *)getSettingsDictionary;
-(NSURL *)getFilePath;
@end
