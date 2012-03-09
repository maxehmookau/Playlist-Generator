//
//  DisplayPlayerPlaylistViewController.m
//  Playlist2
//
//  Created by Max Woolf on 01/03/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DisplayPlayerPlaylistViewController.h"

@implementation DisplayPlayerPlaylistViewController

-(id)initWithTracks:(NSArray *)trackArray
{
    trackURIs = trackArray;
    for(int x = 0; x < [trackURIs count]; x++)
    {
        SPTrack *currentTrack = [self convertURIToTrack:[trackURIs objectAtIndex:x]];
        [tracks addObject:currentTrack];
    }
    return [self init];
}

-(SPTrack *)convertURIToTrack:(NSString *)aURI
{
    SPTrack *currentTrack =  [[SPSession sharedSession]trackForURL:[NSURL URLWithString:aURI]];
    return currentTrack;
}


#pragma mark - Table View Delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [trackURIs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    //SPTrack *currentTrack = [tracks objectAtIndex:indexPath.row];

    [cell.textLabel setText:[trackURIs objectAtIndex:indexPath.row]];
    //[cell.detailTextLabel setText:[[currentTrack artists]objectAtIndex:0]];

    return cell;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    tracks = [[NSMutableArray alloc] init];
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

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

@end
