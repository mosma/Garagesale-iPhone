#import <UIKit/UIKit.h>

@interface SearchViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
 
    NSArray* listaSearchItems;
}

@property (nonatomic, retain) NSArray* listaSearchItems;

@end
