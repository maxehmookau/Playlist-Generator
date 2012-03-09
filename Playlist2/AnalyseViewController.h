/*!
 @class AnalyseViewController
 @discussion This view controller contains the UI elements shown whilst the application tries to identify the piece of music. 
 @author Max Woolf
 
 */


#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AnalysisConnection.h"
#import "SongProfileConnection.h"
#import "EchonestAnalyseConnection.h"
#import "playlist2AppDelegate.h"

@interface AnalyseViewController : UIViewController <MBProgressHUDDelegate, NSURLConnectionDelegate, UIAlertViewDelegate>
{
    /**
     * NSURL Where the recording is stored
     */
    NSURL *recordingURL;
    
    /**
     * The MBProgressHUD where the HUD is stored
     */
    MBProgressHUD *HUD;
    
    /**
     * An AnalysisConnection to send the echoprint code to. 
     */
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
    
    //Core Data Stack
    playlist2AppDelegate *appDelegate;
    NSManagedObjectContext *context;
    
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
