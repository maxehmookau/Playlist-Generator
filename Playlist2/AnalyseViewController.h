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

@interface AnalyseViewController : UIViewController <MBProgressHUDDelegate, NSURLConnectionDelegate>
{
    NSURL *recordingURL;
    MBProgressHUD *HUD;
    AnalysisConnection *analysisConnection;
    SongProfileConnection *songProfileConnection;
    NSMutableData *receivedData;
    NSString *jsonData;
    NSString *trackID;
    NSString *trackTitle;
    NSString *trackArtist;
    
    //UI Elements
    IBOutlet UITextField *artistField;
    IBOutlet UITextField *trackField;
    IBOutlet UIButton *goButton;
}
-(void)showHUD;
-(NSString *)getEchoprintCode;
-(void)getTrackData;
-(IBAction)goButtonPressed:(id)sender;

@property (nonatomic, retain) NSURL *recordingURL;
@property (nonatomic, retain) UITextField *artistField;
@property (nonatomic, retain) UITextField *trackField;
@end
