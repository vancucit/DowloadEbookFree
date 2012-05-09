//
//  AppDelegate.h
//  DowloadEbookFree
//
//  Created by Cuccku on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
@class DownloadManager;

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>
{
      UIBackgroundTaskIdentifier backgroundTask;
}

@property (strong, nonatomic) NSArray                           *arrayExtension;

@property (strong, nonatomic) DownloadManager                   *downloadManager;

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;


- (BOOL)backgroundSupported;

- (void)showHidePlayer:(BOOL) isShow;

- (void)interfaceToOrientation:(UIInterfaceOrientation)interfaceOrientation;
@end
