//
//  NABProjectPrefix.h
//
//  Created by Nguyen Thanh Khoa on 22/8/11.
//  Copyright (c) 2011 Not A Basement Studio®. All rights reserved.
//

//
// How to use:
//
// 1. Add "-ObjC" to "Other Linker Flags"
//
// 2. Import this file in "Reference" mode (by not ticking on "Copy...")
//
// 3. Add these lines to top of your own project prefix file (Ex. ComicExpress-Prefix.pch)
//
//    #import "NABProjectPrefix.h"
//    #define UIAppDelegate ((YourAppDelegateClass *)[UIApplication sharedApplication].delegate)
//
// 4. If using NABMagicalRecord
//
//    #define NAB_PROJECT_PERSISTENT_STORE @"YourProjectCoreDataStore.sqlite"
//    ...
//
//    #ifdef __OBJC__
//        #import "CoreData+MagicalRecord.h"
//    ...
//

#define PROJECT_PERSISTENT_STORE @"MusicData.sqlite"

#define UIAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DEVICE_IS_PHONE ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)

#define DEVICE_IS_IOS_5 ([[[UIDevice currentDevice] systemVersion] compare:@"5.0" options:NSNumericSearch] != NSOrderedAscending)

#define DIRECTORY_DOCUMENT ([NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0])

#define CG_SHOULD_ANTIALIAS NO

#ifdef DEBUG

#define ENABLE_UIKIT_LOG YES
#define ENABLE_CORE_DATA_LOG YES
#define ENABLE_CORE_ANIMATION_LOG YES
#define ENABLE_GESTURES_LOG YES

#define DLog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#define ALog(...) [[NSAssertionHandler currentHandler] handleFailureInFunction:[NSString stringWithCString:__PRETTY_FUNCTION__ encoding:NSUTF8StringEncoding] file:[NSString stringWithCString:__FILE__ encoding:NSUTF8StringEncoding] lineNumber:__LINE__ description:__VA_ARGS__]

#else

#define DLog(...) do { } while (0)
#define ALog(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])

#endif


#ifdef ENABLE_UIKIT_LOG
#define DLogFrame(...) NSLog(@"%s (%f, %f, %f, %f)", __PRETTY_FUNCTION__, __VA_ARGS__.origin.x, __VA_ARGS__.origin.y, __VA_ARGS__.size.width, __VA_ARGS__.size.height)
#define DLogPoint(...) NSLog(@"%s (%f, %f)", __PRETTY_FUNCTION__, __VA_ARGS__.x, __VA_ARGS__.y)
#define DLogSize(...) NSLog(@"%s (%f, %f)", __PRETTY_FUNCTION__, __VA_ARGS__.width, __VA_ARGS__.height)
#define DLogUIKit(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DLogFrame(...) do { } while (0)
#define DLogPoint(...) do { } while (0)
#define DLogSize(...) do { } while (0)
#define DLogUIKit(...) do { } while (0)
#endif


#ifdef ENABLE_CORE_DATA_LOG
#define DLogCoreData(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DLogCoreData(...) do { } while (0)
#endif


#ifdef ENABLE_CORE_ANIMATION_LOG
#define DLogCoreAnimation(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DLogCoreAnimation(...) do { } while (0)
#endif


#ifdef ENABLE_GESTURES_LOG
#define DLogGesture(...) NSLog(@"%s %@", __PRETTY_FUNCTION__, [NSString stringWithFormat:__VA_ARGS__])
#else
#define DLogGesture(...) do { } while (0)
#endif