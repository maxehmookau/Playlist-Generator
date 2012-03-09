/*!
 @class IdentifyViewController
 @discussion This view controller contains the UI elements for beginning and ending a recording as well as creating an instance of the InputRecorder class to record from the build in microphone. 
 @updated 02-28-12
 */

#import <UIKit/UIKit.h>
#import "InputRecorder.h"

@interface IdentifyViewController : UIViewController <AVAudioRecorderDelegate>
{
    
    /** 
     * The record button in the middle of the view
     */
    IBOutlet UIButton *recordButton;
    
    /**
     * The history button
     */
    IBOutlet UIButton *historyButton;
    
    /** 
     * The progess view indicator
     */
    IBOutlet UIProgressView *progressView;
    
    /** 
     * An activity indicator. (Deprecated)
     */
    IBOutlet UIActivityIndicatorView *activityIndicator;
    
    IBOutlet UIImageView *meter0;
    IBOutlet UIImageView *meter1;
    IBOutlet UIImageView *meter2;
    IBOutlet UIImageView *meter3;
    IBOutlet UIImageView *meter4;
    NSArray *meterObjects;  
    
    IBOutlet UIImageView *identifyInstruction;
    IBOutlet UIImageView *historyInstruction;
    IBOutlet UIImageView *arrow1;
    IBOutlet UIImageView *arrow2;
    IBOutlet UIButton *backgroundButton;
    NSArray *toggledElements;
    
    //Background timers
    /** 
     * Timer representing the progress of the recording
     */
    NSTimer *progressTimer;
    /** 
     * Timer fired to generate the average signal power
     */
    NSTimer *powerTimer;
    
    //Recorder
    /** 
     * The InputRecorder object for this instance of UIApplication.
     */
    InputRecorder *inputRecorder;
    
    /** 
     * The current volume of input. 
     */
    float averageVolume;
    
    BOOL startImmediatedly;
}


/*!
 * @function -(IBAction)recordButtonPressed:(id)sender
 * @discussion Called when the record button is pressed. 
 */
-(IBAction)recordButtonPressed:(id)sender;


/*!
 * @function -(IBAction)loadHistory:(id)sender
 * @discussion Called when the history button is pressed 
 */
-(IBAction)loadHistory:(id)sender;

/*!
 * @function -(void)timerFireMethod:(NSTimer*)theTimer
 * @discussion Called everytime an NSTimer fires. 
 */
-(void)timerFireMethod:(NSTimer*)theTimer;

-(void)showAcknowledgements;

@property BOOL startImmediatedly;
@end
