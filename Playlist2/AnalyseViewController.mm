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
    HUD.labelText = @"Identifying";
    HUD.detailsLabelText = @"Generating echoprint code";
	HUD.square = YES;
    HUD.dimBackground = YES;
    HUD.animationType = MBProgressHUDAnimationZoom;
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
    HUD.detailsLabelText = @"Querying echonest database";
    [analysisConnection start];
    HUD.detailsLabelText = @"Waiting for response";
}

-(void)getTrackID
{
    HUD.detailsLabelText = @"";
    
    SBJsonParser *jsonParser = [[SBJsonParser alloc] init];
    NSError *error = nil;
    NSDictionary *jsonObjects = [jsonParser objectWithString:jsonData error:&error];
    NSLog(@"%@", jsonObjects);
    NSDictionary *response = [jsonObjects objectForKey:@"response"];
    NSArray *songs = [response objectForKey:@"songs"];
    
    //Find out whether songs were matched
    if([songs count] == 0)
    {
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"cross.png"]];
        HUD.labelText = @"No Match Found";
        trackID = @"No-Match";
    }else{
        NSDictionary *track = [songs objectAtIndex:0];
        NSString *localTrackID = [track objectForKey:@"id"];
        trackID = localTrackID;
        
        
        songProfileConnection = [[SongProfileConnection alloc] initWithRequest:nil delegate:self trackID:trackID];
        [songProfileConnection start];
        
        
        HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"tick.png"]];
        HUD.labelText = @"Match Found";
    }
    HUD.mode = MBProgressHUDModeCustomView;
    [HUD hide:YES afterDelay:2];
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

#pragma mark - Response methods
//Wait for response!
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    //Just initate the NSData regardless of who made the request.
    [receivedData setLength:0];
    HUD.detailsLabelText = @"Downloading response";
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)d {
    [receivedData setData:d];
    jsonData = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    if(connection == analysisConnection)
    {
        //Deal with identifications
        
        HUD.detailsLabelText = @"Parsing response";
        [self getTrackID];
    }else if(connection == songProfileConnection)
    {
        [self getTrackData];
    }
    
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
    [self showHUD];
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
