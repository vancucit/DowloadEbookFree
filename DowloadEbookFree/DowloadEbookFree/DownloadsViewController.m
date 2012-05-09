	//
//  DownloadsViewController.m
//  DowloadEbookFree
//
//  Created by Cuccku on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

//
//  SecondViewController.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadsViewController.h"
#import "Download.h"
#import "PDColoredProgressView.h"
#import "DownloadManager.h"
//#import "RAPlaylistsController.h"
#import "FilePathUtility.h"


@implementation DownloadsViewController
@synthesize tableView           = _tableView;
@synthesize downloadingCell     = _downloadingCell;
@synthesize downloadQueueCell   = _downloadQueueCell;
@synthesize deleteButton = _deleteButton;
@synthesize moveButton = _moveButton;
@synthesize removeButton = _removeButton;
@synthesize segmentedControl    = _segmentedControl;
@synthesize topViewDownload = _topViewDownload;
@synthesize arrayCurrent        = _arrayCurrent;
@synthesize downloadsSelected   = _downloadsSelected;
@synthesize nameChooseFile = _nameChooseFile;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Download", @"Second");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    _downloadsSelected = [[NSMutableArray alloc] initWithCapacity:0];
    
    UIButton *buttonShowPlayer = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [buttonShowPlayer addTarget:self action:@selector(showPlayer:) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:buttonShowPlayer];
    
    
    
    //[self reloadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dowloadingNotification:) name:@"downloadingProcessNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(downloadErrorNotification:) name:@"downloadError" object:nil];    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSaveNotification:) name:NSManagedObjectContextDidSaveNotification object:[NSManagedObjectContext defaultContext]];
}

- (void)viewDidUnload {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    self.arrayCurrent = nil;    
    [self setTableView:nil];
    [self setDownloadingCell:nil];
    [self setDownloadQueueCell:nil];
    [self setDeleteButton:nil];
    [self setMoveButton:nil];
    [self setRemoveButton:nil];
    [self setTopViewDownload:nil];
    [super viewDidUnload];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
    if (_segmentedControl == nil) {
        NSArray *segmentTextContent = [NSArray arrayWithObjects: @"Downloading", @"Downloaded",@"Not playlist", nil];
        _segmentedControl = [[UISegmentedControl alloc] initWithItems:segmentTextContent];
        _segmentedControl.segmentedControlStyle = UISegmentedControlStyleBar;
        _segmentedControl.selectedSegmentIndex = 0;
        //self.navigationItem.titleView = _segmentedControl;
        
        [_segmentedControl addTarget:self action:@selector(changeViewDownload:) forControlEvents:UIControlEventValueChanged];
        [_topViewDownload addSubview:_segmentedControl];
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return YES;
}


#pragma mark - TableView Delegate 

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    Download *download = (Download *)[_arrayCurrent objectAtIndex:indexPath.row];

    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:indexPath];
    _nameChooseFile = download.name;
    if ([_downloadsSelected indexOfObject:download] == NSNotFound) {
        [_downloadsSelected addObject:download];
        //cell.accessoryType = UITableViewCellAccessoryCheckmark;
   
        // Create the sheet without buttons
        UIActionSheet *sheet = [[UIActionSheet alloc] 
                                initWithTitle:@"Dynamic UIActionSheet"
                                delegate:self
                                cancelButtonTitle:nil
                                destructiveButtonTitle:nil
                                otherButtonTitles:nil];
        
        // Add buttons one by one (e.g. in a loop from array etc...)
        [sheet addButtonWithTitle:@"Open"];
        [sheet addButtonWithTitle:@"Item B"];
        [sheet addButtonWithTitle:@"Item C"];

        // Also add a cancel button
        [sheet addButtonWithTitle:@"Cancel"];
        // Set cancel button index to the one we just added so that we know which one it is in delegate call
        // NB - This also causes this button to be shown with a black background
        sheet.cancelButtonIndex = sheet.numberOfButtons-1;
        
        [sheet showFromRect:self.view.bounds inView:self.view animated:YES];
       
        
    } else {
        [_downloadsSelected removeObject:download];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    cell.selected = NO;
    cell.highlighted = NO;
    
}
- (void)actionSheet:(UIActionSheet *)actionSheet 
clickedButtonAtIndex:(NSInteger)buttonIndex {
	if (buttonIndex == actionSheet.cancelButtonIndex) { return; }
	switch (buttonIndex) {
		case 0:
		{
			NSLog(@"Item A Selected");
            [self testDisplayPDFReader];
			break;
		}
		case 1:
		{
			NSLog(@"Item B Selected");
			break;
		}
		case 2:
		{
			NSLog(@"Item C Selected");
			break;
		}
	}
   
}
#pragma mark UIGestureRecognizer methods

- (void)testDisplayPDFReader
{
    
	NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)  
	    
       
    NSString *rootDirectory = [FilePathUtility rootDirectory];  

    NSString *filePath = [rootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", _nameChooseFile]];  
  
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:filePath];
    if (!fileExists) {
        NSLog(@"Not found file ??????????????");
        return;
    }
    
	ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
	if (document != nil) // Must have a valid ReaderDocument object in order to proceed with things
	{
		ReaderViewController *readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
        
		readerViewController.delegate = self; // Set the ReaderViewController delegate to self
  /*      
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
        
		[self.navigationController pushViewController:readerViewController animated:YES];
        
#else // present in a modal view controller
  */      
		readerViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
		readerViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
		[self presentModalViewController:readerViewController animated:YES];
        

        

	}
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        Download *download = (Download *)[_arrayCurrent objectAtIndex:indexPath.row];
        if (_segmentedControl.selectedSegmentIndex == 0) {
            [UIAppDelegate.downloadManager removeDownloadToQueue:download.downloadId];   
        }             
        
        if ([_downloadsSelected indexOfObject:download] != NSNotFound) {
            [_downloadsSelected removeObject:download];
        }
        
        
        [Download deleteDownloadWithId:download.downloadId];
        [self loadData];
        
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


#pragma mark - TableView Datasouce

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_arrayCurrent count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"downloadingCell";
    static NSString *identifierNormal = @"downloadQueueCell"; 
    
    UITableViewCell *cell;
    Download *download = [_arrayCurrent objectAtIndex:indexPath.row];
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"wat that"); 
        cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil) {
            [[NSBundle mainBundle] loadNibNamed:@"DownloadCell" owner:self options:nil];
            cell = _downloadingCell;
            self.downloadingCell = nil;
        }        
        
        PDColoredProgressView *progress = (PDColoredProgressView *)[cell viewWithTag:3];
        NSLog(@"Progess: %@",progress);
        [progress setTintColor:[UIColor colorWithRed:0.53f green:0.70f blue:0.0f alpha:1.0f]];
        progress.progress = 1.0f;
        
        UILabel *label = (UILabel *)[cell viewWithTag:2];
        label.textColor = [UIColor redColor];
        
        UILabel *labelName  = (UILabel *)[cell viewWithTag:1];
        labelName.textColor = [UIColor redColor];
        
        labelName.text = download.name;
        label.text = [download.downloadId stringValue];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:identifierNormal];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifierNormal];
        }
        
        cell.textLabel.text = download.name;
        NSLog(@"Cell text: %@",download.name);
        cell.textLabel.textColor = [UIColor redColor];
    }    
    if ([_downloadsSelected indexOfObject:download] != NSNotFound) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    return cell;
    
}

#pragma mark - Reload Data

- (IBAction)doDelete:(id)sender {
    
    for (Download *download in  _downloadsSelected) {
        [FilePathUtility deleteDownloadWithDownloadId:download.downloadId];
        
        Download *dowload = [Download downloadWithId:download.downloadId];
        [[NSManagedObjectContext defaultContext] deleteObject:dowload];     
    }
    
    [_downloadsSelected removeAllObjects];    
    [[NSManagedObjectContext defaultContext] save];
    
    [self reloadData];
}

- (IBAction)doMove:(id)sender {
    /*
    RAPlaylistsController *moveController = [[RAPlaylistsController alloc] initWithNibName:@"RAPlaylistsController" bundle:nil];
    moveController.actionType = RAPlaylistsDoActionMove;
    moveController.downloadSelected = _downloadsSelected;
    [self.navigationController pushViewController:moveController animated:YES];
     */
}

- (IBAction)doRemove:(id)sender {
    /*
    RAPlaylistsController *moveController = [[RAPlaylistsController alloc] initWithNibName:@"RAPlaylistsController" bundle:nil];
    moveController.actionType = RAPlaylistsDoActionRemove;
    moveController.downloadSelected = _downloadsSelected;
    [self.navigationController pushViewController:moveController animated:YES];
     */
}

- (void)loadData {
    if (self.arrayCurrent) {
        self.arrayCurrent = nil;
    }
    
    if (_segmentedControl.selectedSegmentIndex == 0) {
        self.arrayCurrent = [Download allDownloadNotDone];
        NSLog(@"Not download : %@",self.arrayCurrent);
    } else if (_segmentedControl.selectedSegmentIndex == 1) {
        self.arrayCurrent = [Download allDownloads];
         NSLog(@"Alls download : %@",self.arrayCurrent);
    } else if (_segmentedControl.selectedSegmentIndex == 2) {
        self.arrayCurrent = [Download allDownloads];
    }
    
    if ([_downloadsSelected count] > 0) {
        [_downloadsSelected removeAllObjects];
    }    
}

- (void)reloadData {
    [self loadData];
    [_tableView reloadData];
    
}

#pragma mark - Download Notification

- (void)downloadErrorNotification:(NSArray *)object {
    NSNumber *downloadId = [object objectAtIndex:0];
    if (downloadId) {
        [self reloadData];
    }
}

- (void)updateProcess:(NSArray *)object {
    if (_segmentedControl.selectedSegmentIndex == 0) {
        float percent = [[object objectAtIndex:0] floatValue];
        
        int downloadId = [[object objectAtIndex:1] intValue];
        
        for (Download *download in [NSArray arrayWithArray:_arrayCurrent]) {
            if ([download.downloadId intValue] == downloadId) {
                int indexRow = [_arrayCurrent indexOfObject:download];
                
                if (indexRow >= 0) {
                    UITableViewCell *cell = [_tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexRow inSection:0]];
                    if (cell) {
                        PDColoredProgressView *progress = (PDColoredProgressView *)[cell viewWithTag:3];
                        progress.progress = percent / 100.0f;                      
                        
                    }
                }
            }
        }  
        
        DLog(@"%d ,%f ", downloadId, percent);
        if (percent == 100.0f) {
            //[self reloadData];
            [self performSelector:@selector(reloadDataSchedule:) withObject:nil afterDelay:1.0f];
        }
    }
    
}
- (void) reloadDataSchedule:(id)sender
{
    [self reloadData];
}
- (void)dowloadingNotification:(NSNotification *)notification {
    NSArray *object = [notification object];
    [self performSelectorOnMainThread:@selector(updateProcess:) withObject:object waitUntilDone:NO];
}


#pragma mark - Hanlder CoreData Save

- (void)handleSaveNotification:(NSNotification *)notification {
}

#pragma mark - Change Value Segment

- (void)changeViewDownload:(id)sender {
    [self reloadData];
}

#pragma mark -Action 

- (void)showPlayer:(id)sender {
    [UIAppDelegate showHidePlayer:YES];
}
#pragma mark ReaderViewControllerDelegate methods

- (void)dismissReaderViewController:(ReaderViewController *)viewController
{
#ifdef DEBUGX
	NSLog(@"%s", __FUNCTION__);
#endif
    
#if (DEMO_VIEW_CONTROLLER_PUSH == TRUE)
    
	//[self.navigationController popViewControllerAnimated:YES];
    
#else // dismiss the modal view controller
    
	[self dismissModalViewControllerAnimated:YES];
    
#endif // DEMO_VIEW_CONTROLLER_PUSH
}

@end
