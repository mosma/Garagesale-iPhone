#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate> {
 
    NSArray* listaSearchItems;
    UISearchBar *searchBar;
}

@property (nonatomic, retain) NSArray* listaSearchItems;
@property (nonatomic, retain) IBOutlet UISearchBar *searchBar;

@end
