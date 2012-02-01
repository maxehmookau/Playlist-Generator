//
//  AddToPlaylistViewController.m
//  Playlist2
//
//  Created by Max Woolf on 30/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AddToPlaylistViewController.h"
#import "CocoaLibSpotify.h"

@implementation AddToPlaylistViewController

-(id)initWithURI:(NSString *)theuri
{
    uri = theuri;
    return [super init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}
#pragma mark - Table Delegate Methods
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [playlistNames count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"playlistIdentifier"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"playlistIdentifier"];
    }
    
    cell.textLabel.text = [playlistNames objectAtIndex:indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

-(void)populateArray
{
    SPPlaylistContainer *container = [SPSession sharedSession].userPlaylists;
    NSMutableArray *playlists = container.playlists;
    playlistNames = [[NSMutableArray alloc] init];
    for(int x = 0; x < [playlists count]; x++)
    {
        SPPlaylist *currentPlaylist = [playlists objectAtIndex:x];
        if([currentPlaylist.owner isEqual:[SPSession sharedSession].user])
        {
            NSLog(@"%@", [currentPlaylist spotifyURL]);
            //[playlistNames addObject:[currentPlaylist name]];
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    NSLog(@"%@", uri);
    [self populateArray];
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
