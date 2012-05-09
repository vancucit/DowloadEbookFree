//
//  AppDelegate.m
//  DowloadEbookFree
//
//  Created by Cuccku on 4/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"


#import "BrowserViewController.h"
#import "DownloadsViewController.h"
#import "FilesViewController.h"
#import "ShareViewController.h"
#import "SettingsViewController.h"
#import "DownloadManager.h"
#import "FilePathUtility.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

@synthesize arrayExtension      = _arrayExtension;
@synthesize downloadManager     = _downloadManager;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{    
    // Override point for customization after application launch.
    [MagicalRecordHelpers setupCoreDataStack];
    
    _downloadManager = [[DownloadManager alloc] init];
    
    self.arrayExtension = [NSArray arrayWithObjects:@"pdf", @"zip", @"rar",  @"3gp", nil];
    
    UIViewController *viewController1, *viewController2, *viewController3, *viewController4, *viewController5;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        viewController1 = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController" bundle:nil];
        viewController2 = [[DownloadsViewController alloc] initWithNibName:@"DownloadsViewController" bundle:nil];
        viewController3 = [[FilesViewController alloc] initWithNibName:@"FilesViewController" bundle:nil];
        viewController4 = [[ShareViewController alloc] initWithNibName:@"ShareViewController" bundle:nil];
        viewController5 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController" bundle:nil];
        
    } else {
        viewController1 = [[BrowserViewController alloc] initWithNibName:@"BrowserViewController_iPad" bundle:nil];
        viewController2 = [[DownloadsViewController alloc] initWithNibName:@"DownloadsViewController_iPad" bundle:nil];
        viewController3 = [[FilesViewController alloc] initWithNibName:@"FilesViewController_iPad" bundle:nil];
        viewController4 = [[ShareViewController alloc] initWithNibName:@"ShareViewController_iPad" bundle:nil];
        viewController5 = [[SettingsViewController alloc] initWithNibName:@"SettingsViewController_iPad" bundle:nil];    }
   
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = [NSArray arrayWithObjects:viewController1, viewController2, viewController3, viewController4, viewController5, nil];
    self.window.rootViewController = self.tabBarController;
    [self.window makeKeyAndVisible];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
			UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            
			backgroundTask = [application beginBackgroundTaskWithExpirationHandler: ^ {
				[application endBackgroundTask: backgroundTask]; //Tell the system that we are done with the tasks
				backgroundTask = UIBackgroundTaskInvalid; //Set the task to be invalid
                
				//System will be shutting down the app at any point in time now
			}];
            
			//Background tasks require you to use asyncrous tasks
            
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				[application endBackgroundTask: backgroundTask]; //End the task so the system knows that you are done with what you need to perform
				backgroundTask = UIBackgroundTaskInvalid; //Invalidate the background_task
			});
		}
	}

}
- (void)copyBackgournd {
    NSString *rootDir = [FilePathUtility rootDirectory];
    
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSArray *dirContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:directory error:nil];
    
    for (NSString *file in dirContents ) {
        NSString *filePath = [directory stringByAppendingPathComponent:file];
        NSString *toPath = [rootDir stringByAppendingPathComponent:[filePath lastPathComponent]];
        
        if ([[NSFileManager defaultManager] fileExistsAtPath:toPath] == YES) {
            DLog(@"file exist");
        } else {
            if ([[NSFileManager defaultManager] moveItemAtPath:rootDir toPath:toPath error:nil]) {
                DLog(@"copy ok");
            } else {
                DLog(@"Faild");
            }
        }
        
        
    }
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    //copy music to public into store 
    [self performSelectorInBackground:@selector(copyBackgournd) withObject:nil];
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/
#pragma mark - Ios Support Background

- (BOOL)backgroundSupported {
	UIDevice* device = [UIDevice currentDevice];
	BOOL backgroundSupported = NO;
	if ([device respondsToSelector:@selector(isMultitaskingSupported)]){
		backgroundSupported = device.multitaskingSupported;
	}
	return backgroundSupported;
}

- (void)interfaceToOrientation:(UIInterfaceOrientation)interfaceOrientation {
    DLog(@"");
    //[self animationArrow:NO];
}
@end
