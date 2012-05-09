//
//  FilePathUtility.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "FilePathUtility.h"
#import "Download.h"


@implementation FilePathUtility

+ (NSString *)rootDirectory {
    NSString *rootDirectory = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"store"];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:rootDirectory]){
        [[NSFileManager defaultManager] createDirectoryAtPath:rootDirectory withIntermediateDirectories:NO attributes:nil error:nil];
    }
    
    return rootDirectory;
}

+ (NSString *)constructPathWidthDownloadId:(NSNumber *)downloadId andUrl:(NSString *)url {
    NSString *rootDirectory = [FilePathUtility rootDirectory];
    NSString *name = [FilePathUtility nameWithUrlString:url];
    NSString *ext = [FilePathUtility extWithUrlString:url];
    if ([UIAppDelegate.arrayExtension indexOfObject:ext] == NSNotFound) {
        ext = @"pdf";
    }
    
    Download *download = [Download downloadWithId:downloadId];
    if (download) {
        if (download.name != nil && ![download.name isEqualToString:@""]) {
            name = [FilePathUtility nameWithUrlString:download.name];
        }
    }
    
    DLog(@"name %@", name);
    NSString *path = [rootDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", name, ext]];
    
    return path;
}

+ (BOOL )deleteDownloadWithDownloadId:(NSNumber *)downloadId {
    Download *download = [Download downloadWithId:downloadId];
    if (download) {
        NSString *path = [FilePathUtility constructPathWidthDownloadId:downloadId andUrl:download.url];
        
        return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
    }
    return NO;
}


+ (NSString *)nameWithUrlString:(NSString *)url {
    if (url) {
        NSString *fileName =  [[url lastPathComponent] stringByDeletingPathExtension];
        if (fileName) {
            fileName = [fileName stringByReplacingOccurrencesOfString:@"(" withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@")" withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@" " withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@"!" withString:@""];
            fileName = [fileName stringByReplacingOccurrencesOfString:@"&" withString:@""];
            return fileName;
        }
    }
    
    return nil;
}


+ (NSString *)extWithUrlString:(NSString *)url {
    if (url) {
        return [[url lastPathComponent] pathExtension];
    }
    
    return nil;
}

@end
