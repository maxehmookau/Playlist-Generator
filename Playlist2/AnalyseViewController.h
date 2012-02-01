//
//  AnalyseViewController.h
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AnalysisConnection.h"
#import "SongProfileConnection.h"
#import "EchonestAnalyseConnection.h"

@interface AnalyseViewController : UIViewController <MBProgressHUDDelegate, NSURLConnectionDelegate>
{
    NSURL *recordingURL;
    MBProgressHUD *HUD;
    AnalysisConnection *analysisConnection;
    EchonestAnalyseConnection *echonestUpload;
    SongProfileConnection *songProfileConnection;
    NSMutableData *receivedData;
    
    //Identified Music
    NSString *jsonData;
    NSString *trackID;
    NSString *trackTitle;
    NSString *trackArtist;
    
    //Analysed Music
    NSString *tempo;
    NSString *danceability;
    NSString *key;
    NSString *mode;
    NSString *energy;
    NSString *timeSignature;
    
    //UI Elements
    //Identified Music
    IBOutlet UITextField *artistField;
    IBOutlet UITextField *trackField;
    IBOutlet UIButton *goButton;
    IBOutlet UIView *identifyView;
    
    //Analysed Music
    IBOutlet UISlider *tempoSlider;
    IBOutlet UISlider *danceSlider;
    IBOutlet UISlider *energySlider;
    IBOutlet UIButton *keyButton;
    IBOutlet UIButton *timeButton;
    IBOutlet UIView *analyseView;
    
}
-(void)showHUD;
-(NSString *)getEchoprintCode;
-(void)getTrackData;
-(void)getAnalysisDataOf:(NSString *)data;
-(IBAction)goButtonPressed:(id)sender;
-(NSString *)convertNumberToKey:(NSString *)inputKey;
-(NSString *)convertnumberToMode:(NSString *)inputMode;

@property (nonatomic, retain) NSURL *recordingURL;
@property (nonatomic, retain) UITextField *artistField;
@property (nonatomic, retain) UITextField *trackField;

@end
