//
//  DownloadManager.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@interface DownloadManager : NSObject {
    
}


@property (nonatomic, strong) NSMutableArray      *operations;

- (void)addDownloadToQueue:(NSNumber *)downloadId;
- (void)removeDownloadToQueue:(NSNumber *)downloadId;

- (void)pauseAllDownloading;
- (void)resumeAllDownloading;

- (void)startDownloading:(NSNumber *)downloadId;
- (void)stopDownloading:(NSNumber *)downloadId;

- (void)populateDownload;

@end
