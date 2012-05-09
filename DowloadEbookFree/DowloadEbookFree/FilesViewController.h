//
//  FilesViewController.h
//  DowloadEbookFree
//
//  Created by Cuccku on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilesViewController : UIViewController

@property (nonatomic, strong) NSMutableData *receivedData;
-(IBAction)testDownLoad:(id)sender;
@end
