/*!
 @class InputRecorder
 @discussion This class creates the required information to begin a recording and save it locally to the device when completed. 
 @updated 02-28-12
 @author Max Woolf
 */

#import <AVFoundation/AVFoundation.h>

@interface InputRecorder : AVAudioRecorder

/**
 * @method
 * @return A dictionary object with the required audio settings
 */
-(NSDictionary *)getSettingsDictionary;

/**
 * @method
 * @return An NSURL object containing the URL where audio should be stored locally on the device. 
 */
-(NSURL *)getFilePath;
@end
