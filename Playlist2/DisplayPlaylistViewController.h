//
//  DisplayPlaylistViewController.h
//  Playlist2
//
//  Created by Max Woolf on 15/12/2011.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DisplayPlaylistViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDataDelegate, UIAlertViewDelegate>
{
    NSArray *artistList;
    NSArray *trackList;
    
    NSMutableArray *activityIndicators;
    NSMutableArray *cells;
    NSMutableArray *URLs;
    
    IBOutlet UITableView *table;
    
    int currentConnectionNumber;
    NSMutableArray *connections;
    
    NSMutableData *receivedData;
}

-(id)initWithArtistArray:(NSArray *)artists tracksArray:(NSArray *)tracks;
@end
