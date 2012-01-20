//
//  EchonestPlaylistParameterViewController.h
//  Playlist2
//
//  Created by Max Woolf on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "EchonestSimilarConnection.h"
#import "MBProgressHUD.h"

@interface EchonestPlaylistParameterViewController : UIViewController <NSURLConnectionDataDelegate>
{
    //Song Info
    NSString *songID;
    
    //UI Elemtents
    IBOutlet UIButton *tracksButton;
    IBOutlet UIStepper *tracksStepper;
    IBOutlet UISlider *danceSlider;
    IBOutlet UISlider *moodSlider;
    IBOutlet UISlider *varietySlider;
    MBProgressHUD *HUD;
     
    //Values for sending to echonest
    float danceability;
    float variety;
    float mood;
    int numberOfTracks;
    
    //Set to true if feeling lucky, then set random values
    BOOL feelingLucky;
    
    //Connection
    EchonestSimilarConnection *connection;
    NSMutableData *receivedData;
    NSString *jsonData;
}

//Initialisation
-(void)setTrackID:(NSString *)inputID;

//Value changes
-(IBAction)tracksStepperValueChange:(id)sender;
-(IBAction)danceSliderValueChange:(id)sender;
-(IBAction)varietySliderValueChange:(id)sender;

//When generate playlist button is pressed
-(IBAction)buttonPressed:(id)sender;
@end
