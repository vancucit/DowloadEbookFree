//
//  DownloadsViewController.h
//  DowloadEbookFree
//
//  Created by Cuccku on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
#import "ReaderViewController.h"

@interface DownloadsViewController : UIViewController <UIActionSheetDelegate, ReaderViewControllerDelegate>

@property (nonatomic, strong) NSArray                       *arrayCurrent;

@property (nonatomic, strong) NSMutableArray                *downloadsSelected;

@property (strong, nonatomic) UISegmentedControl            *segmentedControl;

@property (strong, nonatomic) IBOutlet UIView *topViewDownload;
@property (strong, nonatomic) IBOutlet UITableView          *tableView;
@property (strong, nonatomic) IBOutlet UITableViewCell      *downloadingCell;
@property (strong, nonatomic) IBOutlet UITableViewCell      *downloadQueueCell;
@property (strong, nonatomic) IBOutlet UIButton               *deleteButton;
@property (strong, nonatomic) IBOutlet UIButton               *moveButton;
@property (strong, nonatomic) IBOutlet UIButton               *removeButton;
@property (strong, nonatomic) NSString *nameChooseFile;

- (IBAction)doDelete:(id)sender;
- (IBAction)doMove:(id)sender;
- (IBAction)doRemove:(id)sender;

- (void)loadData;
- (void)reloadData;


@end
