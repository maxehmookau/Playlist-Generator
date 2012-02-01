//
//  AddToPlaylistViewController.h
//  Playlist2
//
//  Created by Max Woolf on 30/01/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddToPlaylistViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
{
    NSMutableArray *playlistNames;
    NSString *uri;
}

-(id)initWithURI:(NSString *)uri;
-(void)populateArray;
@end
