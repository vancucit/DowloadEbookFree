//
//  FilesViewController.m
//  DowloadEbookFree
//
//  Created by Cuccku on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilesViewController.h"
#import "FilePathUtility.h"
#import "ZipArchive.h"
@interface FilesViewController ()

@end

@implementation FilesViewController
@synthesize receivedData;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        // Custom initialization
        self.title = NSLocalizedString(@"Files", @"Files");
        self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
-(IBAction)testDownLoad:(id)sender
{
    NSString *rootDirectory = [FilePathUtility rootDirectory];
   

    NSString *path = [rootDirectory stringByAppendingPathComponent:@"SImpleMediaPlayer.zip"];
    

    
    NSString *filepath = [[NSBundle mainBundle] pathForResource:@"ZipFileName" ofType:@"zip"];
    ZipArchive *zipArchive = [[ZipArchive alloc] init];
    [zipArchive UnzipOpenFile:path Password:@""];
    [zipArchive UnzipFileTo:rootDirectory overWrite:YES];
    [zipArchive UnzipCloseFile];  
}
- (void) connection:(NSURLConnection *)connection
 didReceiveResponse:(NSURLResponse *)response {
    // connection is starting, clear buffer
    NSLog(@"Start download");
    [receivedData setLength:0]; 
}
- (void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // data is arriving, add it to the buffer

    [receivedData appendData:data]; }
- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError *)error {
    // something went wrong, clean up interface as needed 
    NSLog(@"Error");
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection { // all done, we are ready to rock and roll
    // do something with receivedData
    NSLog(@"Finisished");
}
@end
