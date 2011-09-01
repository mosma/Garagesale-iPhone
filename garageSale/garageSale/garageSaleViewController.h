#import <UIKit/UIKit.h>

@interface garageSaleViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
    
    NSArray* listaSecoes;    
    IBOutlet UITableView* customTableView;
}

@property (nonatomic, retain) IBOutlet UITableView* customTableView;
@property (nonatomic, retain) NSArray* listaSecoes;

@end
