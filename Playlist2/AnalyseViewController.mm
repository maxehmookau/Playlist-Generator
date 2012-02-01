//
//  AnalyseViewController.m
//  Playlist2
//
//  Created by Max Woolf on 25/11/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "AnalyseViewController.h"
#import "MBProgressHUD.h"
#import "SBJson.h"
#import "EchonestPlaylistParameterViewController.h"
#import "EchonestAnalyseConnection.h"

@implementation AnalyseViewController
@synthesize recordingURL, artistField, trackField;
extern const char * GetPCMFromFile(char * filename);

#pragma mark - HUD Methods
-(void)showHUD
{
    HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    HUD.dimBackground = YES;
    HUD.labelText = @"Identifying";
    HUD.animationType = MBProgressHUDAnimationFade;
    [HUD show:YES];
}


-(NSString *)getEchoprintCode
{
    const char * fpCode = GetPCMFromFile((char*) [[[recordingURL.absoluteString substringFromIndex:16]stringByReplacingPercentEscapesUsingEncoding:NSASCIIStringEncoding] cStringUsingEncoding:NSASCIIStringEncoding]);
    NSString *cCode = [NSString stringWithCString:fpCode];
    //Set the objects code variable
    //NSLog(@"%@", cCode);
    return cCode;
}

-(void)connectToEchonest
{
    analysisConnection = [[AnalysisConnection alloc] initWithRequest:nil delegate:self echoprintCode:[self getEchoprintCode]];
    [analysisConnection start];
}

-(void)getTrackID
{    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObjects = [jsonParser objectWithString:jsonData error:&error];
    NSLog(@"%@", jsonObjects);
    NSDictionary *response = [jsonObjects objectForKey:@"response"];
    NSArray *songs = [response objectForKey:@"songs"];
    
    //Find out whether songs were matched
    if([songs count] == 0)
    {
        [analyseView setAlpha:1];
        [goButton setAlpha:1];
        [goButton setTitle:@"Generate Playlist" forState:UIControlStateNormal];
        [HUD setLabelText:@"Analysing"];
        [HUD setDetailsLabelText:@"This might take a while..."];
        trackID = @"No-Match";
        echonestUpload = [[EchonestAnalyseConnection alloc] initWithFileURL:recordingURL.absoluteString delegate:self];
        [echonestUpload start];
    }else{
        [goButton setAlpha:1];
        [goButton setTitle:@"Choose Options" forState:UIControlStateNormal];
        [identifyView setAlpha:1];
        NSDictionary *track = [songs objectAtIndex:0];
        NSString *localTrackID = [track objectForKey:@"id"];
        trackID = localTrackID;
        
        
        songProfileConnection = [[SongProfileConnection alloc] initWithRequest:nil delegate:self trackID:trackID];
        [songProfileConnection start];
        HUD.labelText = @"Match Found";
        [HUD hide:YES afterDelay:1];
    }
    
}

-(void)getAnalysisDataOf:(NSString *)data
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObjects = [jsonParser objectWithString:data error:&error];
    NSDictionary *response = [jsonObjects valueForKey:@"response"];
    
    //Check all is ok, then go ahead or show an error.
    if([[[response valueForKey:@"status"]valueForKey:@"code"]isEqualToNumber:[NSNumber numberWithInt:0]])
    {
        NSDictionary *track = [response valueForKey:@"track"];
        NSDictionary *audio_summary = [track valueForKey:@"audio_summary"];
        tempo = [audio_summary valueForKey:@"tempo"];
        danceability = [audio_summary valueForKey:@"danceability"];
        key = [NSString stringWithFormat:@"%@", [audio_summary valueForKey:@"key"]];
        mode = [NSString stringWithFormat:@"%@", [audio_summary valueForKey:@"mode"]];
        energy = [audio_summary valueForKey:@"energy"];
        timeSignature = [NSString stringWithFormat:@"%@", [audio_summary valueForKey:@"time_signature"]];
        
        [tempoSlider setValue:[tempo floatValue]];
        [danceSlider setValue:[danceability floatValue]];
        [energySlider setValue:[energy floatValue]];
        [keyButton setTitle:[NSString stringWithFormat:@"%@ %@", [self convertNumberToKey:key], [self convertnumberToMode:mode]] forState:UIControlStateNormal];
        [timeButton setTitle:timeSignature forState:UIControlStateNormal];
        
        
    }else{
        UIAlertView *fail = [[UIAlertView alloc] initWithTitle:@"That didn't work..." message:@"Echonest is having a bad day, come back later, sorry." delegate:self cancelButtonTitle:@"Alright, bro." otherButtonTitles: nil];
        [fail show];
        NSLog(@"Status Code: %@", [[response valueForKey:@"status"]valueForKey:@"code"]);
    }
}

-(NSString *)convertnumberToMode:(NSString *)inputMode
{
    if([inputMode isEqualToString:@"0"])
    {
        return @"Minor";
    }
    return @"Major";
}

-(NSString *)convertNumberToKey:(NSString *)inputKey
{
    NSArray *keys = [[NSArray alloc] initWithObjects:@"C", @"C#", @"D", @"D#", @"E", @"F", @"F#", @"G", @"G#", @"A", @"A#", @"B", nil];
    
    return [keys objectAtIndex:[inputKey intValue]];
}

-(void)getTrackData
{
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObjects = [jsonParser objectWithString:jsonData error:&error];
    NSDictionary *response = [jsonObjects objectForKey:@"response"];
    NSArray *songs = [response objectForKey:@"songs"];
    NSDictionary *track = [songs objectAtIndex:0];
    trackArtist = [track objectForKey:@"artist_name"];
    trackTitle = [track objectForKey:@"title"];
    artistField.text = trackArtist;
    trackField.text = trackTitle;
}

-(void)goButtonPressed:(id)sender
{
    EchonestPlaylistParameterViewController *nextVC = [[EchonestPlaylistParameterViewController alloc] init];
    [nextVC setTrackID:trackID];
    [nextVC setTitle:@"Generate Playlist"];
    [self.navigationController pushViewController:nextVC animated:YES];
}

#pragma mark - Response methods
//Wait for response!
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //Just initate the NSData regardless of who made the request.
    [receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [receivedData appendData:d];
    jsonData = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    if(connection == analysisConnection)
    {
        //Deal with identifications
        [self getTrackID];
    }else if(connection == songProfileConnection)
    {
        [self getTrackData];
    }else if(connection == echonestUpload)
    {
        [HUD hide:YES afterDelay:1];
        NSLog(@"Getting Data");
        NSLog(@"%@", [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]);
        [self getAnalysisDataOf:[[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding]];
    }
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{

}

#pragma mark - View lifecycle
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

-(void)viewDidAppear:(BOOL)animated
{
    
    [self connectToEchonest];
}

- (void)viewDidLoad
{
    [self.navigationController setTitle:@"Identify"];
    [self showHUD];
    [goButton setAlpha:0];
    [identifyView setAlpha:0];
    [analyseView setAlpha:0];
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
