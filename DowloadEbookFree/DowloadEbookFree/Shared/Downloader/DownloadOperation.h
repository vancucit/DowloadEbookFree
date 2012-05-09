//
//  DownloadOperation.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "QHTTPOperation.h"

@interface DownloadOperation : QHTTPOperation {    
    float				bytesReceived;
	long long			expectedBytes;
    
    BOOL				operationFinished, operationFailed, operationBreaked;
    
    UIBackgroundTaskIdentifier bgTaskDownloadChapter;
}
@property (nonatomic, assign) float             percentComplete;
@property (nonatomic, strong) NSMutableData		*receivedData;
@property (nonatomic, strong) NSString          *filePath;
@property (nonatomic, strong) NSURL             *url;
@property (nonatomic, strong) NSNumber          *downloadOperationId;

- (id)initWithURL:(NSURL *) anUrl withFilePath:(NSString *) afilePath  downloadOperationId: (NSNumber *)downloadOperationId;

@end



