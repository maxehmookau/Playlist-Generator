/*!
 @class HistoryViewController
 @discussion This view controller uses a Core Data persistent store to view all the previously generated playlists so that they can be quickly generated again. 
 @updated 02-28-12
 */

#import <UIKit/UIKit.h>

@interface HistoryViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    /** 
     * References managed object context for Core Data stack.
     */
    NSManagedObjectContext *context;
    
    /** 
     * Mutable array containing all of the playlist managed objects.
     * @discussion This is automatically filled when viewDidLoad: is called.
     */
    NSMutableArray *playlists;
    
    IBOutlet UITableView *table;
}

/*!
 * @function
 * @discussion Use this method to initialised the view controller rather than init.
 */
-(id)customInit;

-(void)clearAll;

@end
