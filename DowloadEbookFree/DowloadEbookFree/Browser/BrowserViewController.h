//
//  FirstViewController.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//
#import <MediaPlayer/MediaPlayer.h>

@interface BrowserViewController : UIViewController <UIWebViewDelegate, UIActionSheetDelegate, UITextFieldDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutlet UIWebView                  *webView;
@property (strong, nonatomic) IBOutlet UITextField                *addressTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView    *activityIndicator;
@property (strong, nonatomic) IBOutlet UIToolbar                  *toolbarBrowser;
@property (strong, nonatomic) IBOutlet UIToolbar                  *toolbarTop;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backWebView;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *forWardWebView;

@property (nonatomic, strong) UITextField                       *downloadName;

@property (nonatomic, strong) NSString                          *urlCurrent;

- (IBAction)goBack:(id)sender;
- (IBAction)goForward:(id)sender;
- (IBAction)goAction:(id)sender;
- (IBAction)goBookmark:(id)sender;
- (IBAction)goRefresh:(id)sender;

- (void)loadURL:(NSURL *)url;
-(BOOL) isFileTypeDownLoad:(NSString*) _stringCheck;
@end
