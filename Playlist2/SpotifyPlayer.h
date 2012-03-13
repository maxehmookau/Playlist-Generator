/**
 * @class SpotifyPlayer
 * @discussion This view controller contains all of the UI elements for loading and playing music using the Spotify API. 
 * @brief Spotify Player View Controller
 * @author Max Woolf
 */

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "CocoaLibSpotify.h"
#import "SPPlaybackManager.h"
#import <MediaPlayer/MediaPlayer.h>
#import "playlist2AppDelegate.h"
#import <CoreData/CoreData.h>

@interface SpotifyPlayer : UIViewController <SPSessionDelegate, SPSessionPlaybackDelegate, UIActionSheetDelegate, AVAudioSessionDelegate>
{
    /**
     * Play pause button on bottom toolbar
     */
    IBOutlet UIBarButtonItem *playPauseButton;
    
    /**
     * Track name label
     */
    IBOutlet UILabel *trackLabel;
    
    /**
     * Artist name label
     */
    IBOutlet UILabel *artistLabel;
    
    /**
     * Cover image view. Populated automatically.
     */
    IBOutlet UIImageView *coverImageView;
    
    /**
     * Seeking progress meter
     */
    IBOutlet UISlider *progressMeter;
    
    /**
     * Bottom toolbar reference for previous and next tracks
     */
    IBOutlet UIToolbar *bottomToolbar;
    
    /**
     * Information display
     */
    MBProgressHUD *hud;
    
    /**
     * Shared instance which holds information for the lock screen
     */
    MPNowPlayingInfoCenter *nowPlaying;
    
    /**
     * Data of the currently playing track.
     */
    NSMutableDictionary *nowPlayingInfo;
    
    /**
     * The array of URIs to be played
     */
    NSArray *trackURIs;
    
    /**
     * An integer index of the currently playing track in trackURIs
     */
    int currentTrackPlayingIndex;
    
    /**
     * An instance of SPPlaybackManager to manage audio streaming
     */
    SPPlaybackManager *manager;
    
    /**
     * The duration of the currently playing track. Used to determine length of progress meter.
     */
    NSTimeInterval currentTrackDuration;
    
    /**
     * Used to time the length of the track
     */
    NSTimer *timer;
    
    /**
     * The entered username
     */
    NSString *spotifyUsername;
    
    /**
     * The entered password
     */
    NSString *spotifyPassword;
}

/**
 * @function
 * @param aUsername A valid Spotify Premium username.
 * @param aPassword A valid Spotify Premium password.
 * @brief This view must be initialised with this method. Failure to provide a valid user/pass combination
 * will display an error. 
 */
-(id)initWithUserName:(NSString *)aUsername password:(NSString *)aPassword;

/*!
 * @function
 * @param theArray The array of tracks to be played. 
 * @brief Called in the previous view controller, this method fills the array with tracks to be played.
 */
-(void)setArray:(NSArray *)theArray;

/*!
 * @function
 * @param username A valid Spotify Premium username
 * @param password A valid Spotify Premium password
 * @brief This method creates a SPSpotify session to connect to the Spotify API.
 */
-(void)loginToSpotifyWithUsername:(NSString *)username andPassword:(NSString *)password;

/*!
 * @function
 * @param index The index of trackURIs to be played
 * @brief This method causes the track at index to be loaded and played.
 */
-(void)playTrackAtIndex:(NSNumber *)index;

/*!
 * @function
 * @param track An SPTrack object
 * @brief This method causes the track object to load its album cover as an SPImage.
 */
-(void)getCoverImageForTrack:(SPTrack *)track;

/*!
 * @function
 * @param theTimer The NSTimer object that fired
 * @brief This method is called automatically when any NSTimer fires.
 */
-(void)timerFireMethod:(NSTimer*)theTimer;

/**
 * @function
 * @brief This method sets up the audio session to be used.
 */
-(void) initAudioSession;

/**
 * @function
 * @param aSession The Spotify session to be queried. This is usually [SPSession sharedSession].
 * @attention This is used for debugging and serves no use in a production environment.
 */
-(void) displayCurrentSpotifyStatusForSession:(SPSession *)aSession;


/**
 * @function 
 * @brief Toggles the track to play or pause
 */
-(IBAction)togglePlayPause:(id)sender;

/**
 * @function
 * @brief Causes the playback manager to begin playing the next track
 */
-(IBAction)nextTrack:(id)sender;

/**
 * @function
 * @brief Causes the playback manager to begin playing the previous track
 */
-(IBAction)previousTrack:(id)sender;

/**
 * @function
 * @brief Causes the playback manager to seek to the selected position
 */
-(IBAction)movedSlider:(id)sender;

/**
 * @function
 * @brief Logs out of Spotify and pops to the root view controller
 */
-(void)goHome;


@end
