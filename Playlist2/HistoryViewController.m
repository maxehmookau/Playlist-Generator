//
//  HistoryViewController.m
//  Playlist2
//
//  Created by Max Woolf on 27/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HistoryViewController.h"
#import "playlist2AppDelegate.h"
#import "EchonestPlaylistParameterViewController.h"
@implementation HistoryViewController

-(id)customInit
{
    playlist2AppDelegate *appDelegate = (playlist2AppDelegate *)[[UIApplication sharedApplication] delegate];
    context = appDelegate.managedObjectContext;
    return [self init];
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - Table Delegate

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle 
forRowAtIndexPath:(NSIndexPath *)indexPath {
    // If row is deleted, remove it from the list.
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        //remove from local array and persistent storage
        [context deleteObject:[playlists objectAtIndex:indexPath.row]];
        [context save:nil];
        [playlists removeObjectAtIndex:indexPath.row];
       
        
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationAutomatic]; 
        
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [playlists count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *cellIdentifier = @"Cell";

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }

    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    [cell.textLabel setText:[NSString stringWithFormat:@"%@ - %@", [[playlists objectAtIndex:indexPath.row]valueForKey:@"artist"], [[playlists objectAtIndex:indexPath.row]valueForKey:@"title"] ]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EchonestPlaylistParameterViewController *nextVC = [[EchonestPlaylistParameterViewController alloc] init];
    [nextVC setTrackID:[[playlists objectAtIndex:indexPath.row]valueForKey:@"id"]];
    nextVC.trackWasIdentified = YES;
    [self.navigationController pushViewController:nextVC animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [self setTitle:@"History"];
    [self.navigationController setNavigationBarHidden:NO];
    NSFetchRequest *fetch = [[NSFetchRequest alloc] init];
    [fetch setEntity:[NSEntityDescription entityForName:@"Track" inManagedObjectContext:context]];
    playlists = [NSMutableArray arrayWithArray:[context executeFetchRequest:fetch error:nil]];
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
