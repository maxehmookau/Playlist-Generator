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
#import "DisplayPlaylistViewController.h"

@interface EchonestPlaylistParameterViewController : UIViewController <NSURLConnectionDataDelegate>
{
    //Session Info
    BOOL trackWasIdentified;
    
    //Song Info
    NSString *songID; //ID of a song if it was recognised
    NSDictionary *analysisData; //Dictionary containing data about an analysis
    
    //UI Elemtents
    IBOutlet UIButton *tracksButton;
    IBOutlet UIStepper *tracksStepper;
    IBOutlet UISlider *danceSlider;
    IBOutlet UISlider *moodSlider;
    IBOutlet UISlider *varietySlider;
    IBOutlet UIView *slidersView;
    MBProgressHUD *HUD;
     
    //Values for sending to echonest
    float danceability;
    float variety;
    float mood;
    int numberOfTracks;
    
    //Set to true if feeling lucky, then set random values
    BOOL feelingLucky;
    
    //Connection
    NSURLConnection *connection;
    NSMutableData *receivedData;
    NSString *jsonData;
    DisplayPlaylistViewController *nextVC;
    NSMutableData *inputData;
}

//Initialisation
-(void)setTrackID:(NSString *)inputID;
-(void)setDictionaryData:(NSDictionary *)inputDict;

//Value changes
-(IBAction)tracksStepperValueChange:(id)sender;
-(IBAction)danceSliderValueChange:(id)sender;
-(IBAction)varietySliderValueChange:(id)sender;

//When generate playlist button is pressed
-(IBAction)buttonPressed:(id)sender;

@property (nonatomic) BOOL trackWasIdentified;
@end
