//
//  FirstViewController.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BrowserViewController.h"
#import "Download.h"
#import "DownloadManager.h"
#import "FilePathUtility.h"
#import "AddBookmarkViewController.h"
#import "ViewBookmarkViewController.h"

#define kTagActionSheetDownload 11
#define kTagActionSheetAddBookMark 12
@implementation BrowserViewController
@synthesize webView             = _webView;
@synthesize addressTextField    = _addressTextField;
@synthesize activityIndicator   = _activityIndicator;
@synthesize toolbarBrowser      = _toolbarBrowser;
@synthesize toolbarTop          = _toolbarTop;
@synthesize backWebView = _backWebView;
@synthesize forWardWebView = _forWardWebView;
@synthesize downloadName        = _downloadName;
@synthesize urlCurrent          = _urlCurrent;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        //        self.title = NSLocalizedString(@"First", @"First");
        //        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    //t
    _webView.delegate = self;
   // [self loadURL:[NSURL URLWithString:@"http://www.gutenberg.org/files/2591/2591-pdf.pdf"]];
    //[self loadURL:[NSURL URLWithString:@"https://github.com/vfr/Reader/zipball/master"]];
    //[self loadURL:[NSURL URLWithString:@"http://www.mediafire.com/?9lnlxp0y6hhss6w"]];
    //[self loadURL:[NSURL URLWithString:@"https://github.com/vfr/Reader/"]];
    [self loadURL:[NSURL URLWithString:@"http://www.scribd.com/doc/83187932/Facebook-Timeline-For-Pages-Product-Guide-from-TechCrunch"]];
    _activityIndicator.hidesWhenStopped = YES;
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleBlackOpaque];
    
}

- (void)viewDidUnload {
    [self setWebView:nil];
    [self setAddressTextField:nil];
    [self setActivityIndicator:nil];
    [self setBackWebView:nil];
    [self setForWardWebView:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    //    _toolbarTop.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 44.0f);
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    [UIAppDelegate interfaceToOrientation:toInterfaceOrientation];
}

#pragma mark - Do Action

- (IBAction)goBack:(id)sender {
    [_webView goBack];
}

- (IBAction)goForward:(id)sender {
    [_webView goForward];
}

- (IBAction)goAction:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[_webView.request.URL relativeString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"Add bookmark", nil];
    actionSheet.tag = kTagActionSheetAddBookMark;
    actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
    
    [actionSheet showFromToolbar:_toolbarBrowser];
}

- (IBAction)goBookmark:(id)sender {
    ViewBookmarkViewController * viewBookmarkViewController = [[ViewBookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    viewBookmarkViewController.delegate = self;
    [viewBookmarkViewController setBookmark:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"]
                                        url:_webView.request.URL];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:viewBookmarkViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:navController animated:YES];
}
- (IBAction)goRefresh:(id)sender
{
    [_webView reload];
}
#pragma mark - Webview Delegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"URL : %@", request);
    if ([[[request URL] scheme] isEqual:@"http"] && [self isFileTypeDownLoad:[[request URL] pathExtension]]) {
        NSLog(@"zip file detect");
        self.urlCurrent = [request URL].relativeString;
    
        // open a alert with text field,  OK and cancel button
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Add playlist" message:@" "
                                                       delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Save", nil];
        CGRect frame = CGRectMake(14, 45, 255, 23);
        if(!_downloadName) {
            _downloadName = [[UITextField alloc] initWithFrame:frame];
            
            _downloadName.borderStyle = UITextBorderStyleBezel;
            _downloadName.textColor = [UIColor blackColor];
            _downloadName.textAlignment = UITextAlignmentCenter;
            _downloadName.font = [UIFont systemFontOfSize:14.0];
            _downloadName.text = [[request URL] lastPathComponent];
            _downloadName.placeholder = @"<enter name>";
            
            _downloadName.backgroundColor = [UIColor whiteColor];
            _downloadName.autocorrectionType = UITextAutocorrectionTypeNo;	// no auto correction support
            
            _downloadName.keyboardType = UIKeyboardTypeAlphabet;	// use the default type input method (entire keyboard)
            _downloadName.returnKeyType = UIReturnKeyDone;
            _downloadName.delegate = self;
            _downloadName.clearButtonMode = UITextFieldViewModeWhileEditing;	// has a clear 'x' button to the right
        }
        
        [alert addSubview:_downloadName];
        
        [alert show];
        
        [_downloadName becomeFirstResponder];
        
        return NO;
    }    
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    DLog(@"start load");
    [_activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    DLog(@"finish loading");
    [_activityIndicator stopAnimating];
    
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    
}

#pragma mark - Stuff

- (void)loadURL:(NSURL *)url {
  //  if (!url) return;
    
    _addressTextField.text = url.relativeString;
    //check filetype download or open
    NSLog(@"url: %@ - %@ - %@", url, url.pathExtension,url.lastPathComponent);

    if ([self isFileTypeDownLoad:url.pathExtension]) {
        //show action sheet here
        UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:[[_webView.request.URL relativeString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]
                                                                 delegate:self
                                                        cancelButtonTitle:@"Cancel"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"Open", @"Download", nil];
        actionSheet.actionSheetStyle = UIActionSheetStyleDefault;
        actionSheet.tag = kTagActionSheetDownload;
        [actionSheet showFromToolbar:_toolbarBrowser];
        return;
    }
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
}
-(BOOL) isFileTypeDownLoad:(NSString*) _stringCheck
{
    NSArray *arrayCheck = [NSArray arrayWithObjects:@"pdf",@"zip",@"rar", nil];
    for (NSString *stringType in arrayCheck) {
        if ([_stringCheck isEqualToString:stringType]) {
            return YES;
        }
    }
    return NO;
}
#pragma mark actionsheet download
-(void) goDownload
{
    NSLog(@"Processing download here");
}
-(void) openWebNormal
{
    NSURL *url = [NSURL URLWithString:_addressTextField.text];
    
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:_addressTextField.text]];
    } else {
        url = [NSURL URLWithString:_addressTextField.text];
    }
    
    [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    
    [_addressTextField resignFirstResponder];
}
- (void)addBookmark {
    AddBookmarkViewController * addBookmarkViewController = [[AddBookmarkViewController alloc] initWithStyle:UITableViewStyleGrouped];
    [addBookmarkViewController setBookmark:[_webView stringByEvaluatingJavaScriptFromString:@"document.title"]
                                       url:_webView.request.URL];
    addBookmarkViewController.delegate = self;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:addBookmarkViewController];
    
    navController.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    
    [self presentModalViewController:navController animated:YES];
}

#pragma mark - UITextField delegate

- (BOOL) textFieldShouldReturn:(UITextField *) textField {
    NSURL *url = [NSURL URLWithString:_addressTextField.text];
    
    // if user didn't enter "http", add it the the url
    if (!url.scheme.length) {
        url = [NSURL URLWithString:[@"http://" stringByAppendingString:_addressTextField.text]];
    } else {
        url = [NSURL URLWithString:_addressTextField.text];
    }
    [_addressTextField resignFirstResponder];
    [self loadURL:url];    
   // [_webView loadRequest:[NSURLRequest requestWithURL:url]];
    

    
    return YES;
}

#pragma marl - Action Sheet Delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (actionSheet.tag == kTagActionSheetDownload) {
        switch (buttonIndex) {
            case 0:
            {
                //open Url
                [self openWebNormal];
                break;
            }
            case 1:
            {
                //download URL
                [self goDownload];
                break;                
            }
            case 2:
            {
                break;
            }
            default:
                break;
        }
    }
    else if (actionSheet.tag == kTagActionSheetAddBookMark)
    {
        if (buttonIndex == 0) {
            [self addBookmark];
        }
    }
    
}

#pragma mark - Bookmark delegates

- (void)openThisURL:(NSURL *)url {
    [self loadURL:url];
}

- (void)dismissViewBookmMarkViewController:(ViewBookmarkViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - addBookmark delegates

- (void)dismissAddBookmMarkViewController:(AddBookmarkViewController *)viewController {
    [viewController dismissModalViewControllerAnimated:YES];
}

#pragma mark - UIAlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        if (_urlCurrent.length > 0) {
            Download *download = [Download createInContext:[NSManagedObjectContext defaultContext]];
            download.url = _urlCurrent;
            download.downloadId = [Download maxDownloadId];
            download.status = [NSNumber numberWithInt:DownloadStatusNone];
            download.name = _downloadName.text;
            
            [[NSManagedObjectContext defaultContext] save];            
            _downloadName.text = nil;
            
            [UIAppDelegate.downloadManager populateDownload];
        }
        
    }
}

@end
