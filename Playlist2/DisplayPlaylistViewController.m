//
//  DisplayPlaylistViewController.m
//  Playlist2
//
//  Created by Max Woolf on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DisplayPlaylistViewController.h"
#import "SpotifyURILookup.h"
#import "ExtractSpotifyURI.h"
#import "URIToURLConverter.h"
#import "SpotifyPlayer.h"

@implementation DisplayPlaylistViewController

-(id)initWithArtistArray:(NSArray *)artists tracksArray:(NSArray *)tracks
{
    artistList = artists;
    trackList = tracks;
    self = [super init];
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table View Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([artistList count] == [trackList count])
    {
        return [artistList count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *MyIdentifier = @"MyIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:MyIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:MyIdentifier];
        [cell.textLabel setText:[trackList objectAtIndex:indexPath.row]];
        [cell.detailTextLabel setText:[artistList objectAtIndex:indexPath.row]];
        //[cell setAccessoryView:[activityIndicators objectAtIndex: indexPath.row]];
        //[[activityIndicators objectAtIndex:indexPath.row] startAnimating];
        [cell setAccessoryType:UITableViewCellAccessoryNone];
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    [cells addObject:cell];
    return cell;
}

#pragma mark - Connection Delegate
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSString *receivedString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    ExtractSpotifyURI *extractor = [[ExtractSpotifyURI alloc] initWithSpotifyJSONString:receivedString];
    [URLs addObject:[extractor getURI]];
    
    //When done, increase the connection number, and run the next connection
    currentConnectionNumber++;
    //And sleep, spotify gets grumpy otherwise
    sleep(3);
    if(currentConnectionNumber < [connections count])
    {
        SpotifyURILookup *nextConnection = [connections objectAtIndex:currentConnectionNumber];
        [nextConnection start];
    }else{
        UIAlertView *spotifyLoginAlert = [[UIAlertView alloc] initWithTitle:@"Login to Spotify" message:nil delegate:self cancelButtonTitle:nil otherButtonTitles: @"Login", nil];
        [spotifyLoginAlert setAlertViewStyle:UIAlertViewStyleLoginAndPasswordInput];
        [spotifyLoginAlert show];
    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    SpotifyPlayer *player = [[SpotifyPlayer alloc]init];
    [player setArray:URLs];
    [self.navigationController pushViewController:player animated:YES];
    
    //Login performed... get logging in to spotify!
}


#pragma mark - View lifecycle

-(void)viewDidAppear:(BOOL)animated
{
    for(int x = 0; x < [artistList count]; x++)
    {
        SpotifyURILookup *spotifyJSONConnecton = [[SpotifyURILookup alloc] initWithTrackName:[trackList objectAtIndex:x] artistName:[artistList objectAtIndex:x] delegate:self];
        [connections addObject:spotifyJSONConnecton];
        //Add each connection to an array and do it one by one. 
    }
    //Set connection 1 off. 
    if(currentConnectionNumber == 0)
    {
        SpotifyURILookup *currentConnection = [connections objectAtIndex:0];
        [currentConnection start];
    }
}

- (void)viewDidLoad
{
    currentConnectionNumber = 0;
    URLs = [[NSMutableArray alloc] initWithCapacity:[artistList count]];
    //Create lots of activity indicators so that they are held within the VC
    activityIndicators = [[NSMutableArray alloc] initWithCapacity:[artistList count]];
    for(int x = 0; x < [artistList count]; x++)
    {
        UIActivityIndicatorView *currentAI = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activityIndicators addObject:currentAI];
    }
    connections = [[NSMutableArray alloc] initWithCapacity:[artistList count]];
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
