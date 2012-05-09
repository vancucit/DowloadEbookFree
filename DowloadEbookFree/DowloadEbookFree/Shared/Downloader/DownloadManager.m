//
//  DownloadManager.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadManager.h"
#import "DownloadOperation.h"
#import "Download.h"
#import "FilePathUtility.h"

@implementation DownloadManager
@synthesize operations = _operations;
#pragma mark - Init

- (id)init {
    self = [super init];
    if (self) {
        _operations = [[NSMutableArray alloc] initWithCapacity:0];
        
        [self populateDownload];
    }
    return self;
}

#pragma mark - Download Finised Target

- (void)finishedDownload:(DownloadOperation *) operation {
    Download *download = [Download downloadWithId:operation.downloadOperationId];
    
    if (operation != nil && operation.error != nil) {
        DLog(@"%@", operation.error);
        [Download deleteDownloadWithId:download.downloadId];
        
        NSArray *objectSend = [NSArray arrayWithObjects:download.downloadId, operation.error , nil];            
        [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadError" object:objectSend];
        return;
    }
    
    DLog(@"");    
    download.status = [NSNumber numberWithInt:DownloadStatusDone];
    [[NSManagedObjectContext defaultContext] save];
    
    [_operations removeObject:operation];
    
    
    [self populateDownload];
    
}

#pragma mark - Add and Remove Queue

- (void)addDownloadToQueue:(NSNumber *)downloadId {
    Download *download = [Download downloadWithId:downloadId];
    
    if (download != nil) {
        download.status = [NSNumber numberWithInt:DownloadStatusProcessing];
        
        NSURL *url = [NSURL URLWithString:download.url];
        DLog(@"%d - Download url %@", [download.downloadId  intValue] ,[url relativeString]);
        DownloadOperation *operation = [[DownloadOperation alloc] initWithURL:url withFilePath:[FilePathUtility constructPathWidthDownloadId:downloadId andUrl:[url relativeString]] downloadOperationId:downloadId];
        
        [_operations addObject:operation];
        
        [[NetworkManager sharedManager] addNetworkTransferOperation:operation finishedTarget:self action:@selector(finishedDownload:)];
        
        
    }
}

- (void)removeDownloadToQueue:(NSNumber *)downloadId {
    Download *download = [Download downloadWithId:downloadId];
    
    for (DownloadOperation *operation in _operations) {
        if ([download.url isEqualToString:[operation.url relativeString]]) {
            [[NetworkManager sharedManager] cancelOperation:operation];
            [_operations removeObject:operation];
        }
    }
}

#pragma mark - Pause and Resum Queue

- (void)pauseAllDownloading {
    
}

- (void)resumeAllDownloading {
    
}

#pragma mark - Star and Stop Download

- (void)startDownloading:(NSNumber *)downloadId {
    
}

- (void)stopDownloading:(NSNumber *)downloadId {
    
}

#pragma mark - Populate Download 

- (void)populateDownload {
    int countOp = [_operations count];
    if (countOp < 5) {
        NSArray *arrayNotDownload = [Download allDownloadNotDone];
        int numberAddToQueue = 5 - countOp;
        
        int i = 0;
        for (Download *download in arrayNotDownload) {
            if (i < numberAddToQueue && ([_operations indexOfObject:download] == NSNotFound)) {
                [self addDownloadToQueue:download.downloadId];
            }
            
            i++;
        }
    }
}

@end
