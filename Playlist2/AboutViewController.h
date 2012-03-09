//
//  AboutViewController.h
//  Playlist2
//
//  Created by Max Woolf on 28/02/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AboutViewController : UIViewController
{
    IBOutlet UIWebView *webView;
    IBOutlet UIBarButtonItem *closeButton;
}

-(IBAction)close:(id)sender;
@end
