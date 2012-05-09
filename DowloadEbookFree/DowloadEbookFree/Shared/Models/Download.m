//
//  Download.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Download.h"
#import "Categories.h"
#import "FilePathUtility.h"

@implementation Download

@dynamic downloadId;
@dynamic status;
@dynamic url;
@dynamic name;
@dynamic type;
@dynamic path;
@dynamic processPercent;
@dynamic belongToCategory;

+ (NSArray *)allDownloads {
    return [Download findAll];
}

+ (NSArray *)allDownloadNotDone {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"(status = %d) OR (status = %d)", DownloadStatusNone, DownloadStatusProcessing]];
    
    return [Download findAllSortedBy:@"status" ascending:YES withPredicate:predicate];
}

+ (NSArray *)allDownloaded {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status = %d", DownloadStatusDone]];
    
    return [Download findAllSortedBy:@"status" ascending:YES withPredicate:predicate];
}

+ (Download *)downloadWithId:(NSNumber *)downloadId {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"downloadId = %@", downloadId]];
    
    return [Download findFirstWithPredicate:predicate];
}

+ (NSArray *)downloadsWithStatus:(DownloadStatus )status {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"status = %d", status]];
    
    return [Download findAllWithPredicate:predicate];
}

+ (NSArray *)downloadsWithCategory:(Categories *)category {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"belongToCategory.categoryId = %@", category.categoryId]];
    
    return [Download findAllWithPredicate:predicate];
}

+ (void )deleteDownloadWithId:(NSNumber *)downloadId {
    //delete file
    [FilePathUtility deleteDownloadWithDownloadId:downloadId];
    
    Download *dowload = [Download downloadWithId:downloadId];
    [[NSManagedObjectContext defaultContext] deleteObject:dowload];
    [[NSManagedObjectContext defaultContext] save];
}

+ (NSNumber *)maxDownloadId {
    Download *dowload  = [self findFirstWithPredicate:nil sortedBy:@"downloadId" ascending:NO andRetrieveAttributes:[NSArray arrayWithObject:@"downloadId"]];
    
    int downloadId = 1;
    if (dowload) {
        downloadId = [dowload.downloadId intValue] + 1;
    }
    
    return [NSNumber numberWithInt:downloadId];
}

@end
