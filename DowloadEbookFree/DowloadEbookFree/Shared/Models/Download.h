//
//  Download.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

@class Categories;

typedef enum {
	DownloadStatusNone = 0,
	DownloadStatusProcessing,
	DownloadStatusDone
}DownloadStatus;

@interface Download : NSManagedObject

@property (nonatomic, strong) NSNumber * downloadId;
@property (nonatomic, strong) NSNumber * status;
@property (nonatomic, strong) NSString * url;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * type;
@property (nonatomic, strong) NSString * path;
@property (nonatomic, strong) NSNumber * processPercent;
@property (nonatomic, strong) Categories *belongToCategory;

+ (NSArray *)allDownloads;
+ (NSArray *)allDownloadNotDone;
+ (NSArray *)allDownloaded;

+ (NSArray *)downloadsWithStatus:(DownloadStatus )status;
+ (NSArray *)downloadsWithCategory:(Categories *)category;

+ (Download *)downloadWithId:(NSNumber *)downloadId;

+ (void )deleteDownloadWithId:(NSNumber *)downloadId;

+ (NSNumber *)maxDownloadId;

@end
