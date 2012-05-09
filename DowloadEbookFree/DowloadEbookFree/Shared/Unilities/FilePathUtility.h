//
//  FilePathUtility.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@interface FilePathUtility : NSObject

+ (NSString *)rootDirectory;

+ (NSString *)constructPathWidthDownloadId:(NSNumber *)downloadId andUrl:(NSString *)url;


+ (NSString *)nameWithUrlString:(NSString *)url;
+ (NSString *)extWithUrlString:(NSString *)url;

+ (BOOL )deleteDownloadWithDownloadId:(NSNumber *)downloadId;


@end
