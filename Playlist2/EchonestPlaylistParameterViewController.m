 //
//  EchonestPlaylistParameterViewController.m
//  Playlist2
//
//  Created by Max Woolf on 10/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "EchonestPlaylistParameterViewController.h"
#import "MBProgressHUD.h"
#import "ReadPlaylistSuggestions.h"
#import "DisplayPlaylistViewController.h"
#import "AnalysedPlaylistConnection.h"

@implementation EchonestPlaylistParameterViewController
@synthesize trackWasIdentified;
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Initialisation
-(void)setTrackID:(NSString *)inputID
{
    if(songID != inputID)
    {
        songID = inputID;
    }
}

-(void)setDictionaryData:(NSDictionary *)inputDict
{
    if(analysisData != inputDict)
    {
        analysisData = inputDict;
    }
}

#pragma mark - Value Changes
-(IBAction)tracksStepperValueChange:(id)sender
{
    //Cast value to make int, gets rid of those pesky decimals
    numberOfTracks = (int)tracksStepper.value;
    [tracksButton setTitle:[NSString stringWithFormat:@"%i", numberOfTracks]forState:UIControlStateNormal];
}

-(IBAction)danceSliderValueChange:(id)sender
{
    danceability = danceSlider.value;
}
-(IBAction)varietySliderValueChange:(id)sender
{
    variety = varietySlider.value;
}

#pragma mark - Generation
-(void)buttonPressed:(id)sender
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    [HUD setMode:MBProgressHUDModeIndeterminate];
    [HUD setLabelText:@"Please Wait"];
    [HUD show:YES];
    if(trackWasIdentified)
    {
        //Run a similar connection on the identified track ID
        connection = [[EchonestSimilarConnection alloc] initWithRequest:nil delegate:self trackID:songID danceability:danceability variety:variety numberOfTracks:numberOfTracks];
        [connection start];
    }else{
        //Run a connection based on the musical data collection
        connection = [[AnalysedPlaylistConnection alloc] initWithDanceability:[analysisData valueForKey:@"Danceability"] energy:[analysisData valueForKey:@"Energy"] tempo:[analysisData valueForKey:@"Tempo"] key:[analysisData valueForKey:@"Key"] mode:[analysisData valueForKey:@"Mode"] results:[NSString stringWithFormat:@"%i",numberOfTracks] delegate:self];
        [connection start];
    }
    
}

#pragma mark - URL Connection Delegate
//Wait for response!
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //Just initate the NSData regardless of who made the request.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"%@", [error localizedDescription]);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [receivedData appendData:d];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    ReadPlaylistSuggestions *jsonReader = [[ReadPlaylistSuggestions alloc] initWithJsonData:receivedData];
    nextVC = [[DisplayPlaylistViewController alloc] initWithArtistArray:[jsonReader getArtistList] tracksArray:[jsonReader getTrackList]];
    [self.navigationController pushViewController:nextVC animated:YES];
    [HUD removeFromSuperview];
    
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setTitle:@"Options"];
    receivedData = [[NSMutableData alloc] init];
    //If the track wasn't identified, get rid of the settings. 
    if(!trackWasIdentified)
    {
        [slidersView setAlpha:0];
    }
    numberOfTracks = 10;
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
