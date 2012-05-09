//
//  DownloadOperation.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "DownloadOperation.h"
#import "FilePathUtility.h"

@implementation DownloadOperation
@synthesize url         = _url;
@synthesize filePath    = _filePath;
@synthesize receivedData;
@synthesize percentComplete;
@synthesize downloadOperationId = _downloadOperationId;

#pragma mark - Constructor

- (id)initWithURL:(NSURL *) anUrl withFilePath:(NSString *) afilePath  downloadOperationId: (NSNumber *)downloadOperationId {
    self = [super initWithURL:anUrl];
    if (self) {
        receivedData = [[NSMutableData alloc] initWithLength:0];
        
        self.downloadOperationId = downloadOperationId;
        self.url = anUrl;
		self.filePath = afilePath;
        
        if ([UIAppDelegate backgroundSupported]) {
            bgTaskDownloadChapter = [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:^{
                DLog(@"bgTaskDownloadChapter - start");
                [[UIApplication sharedApplication] endBackgroundTask:bgTaskDownloadChapter];
                bgTaskDownloadChapter = UIBackgroundTaskInvalid;
            }];
        }
    }
        
    return self;
}

#pragma mark - NSURLConnection delegate override 

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [super connection:connection didReceiveResponse:response];
    
//	DLog(@"[DO::didReceiveData] ddb: %.2f, wdb: %.2f, ratio: %.2f", (float)bytesReceived, (float)expectedBytes,(float)bytesReceived / (float)expectedBytes);
	
	NSHTTPURLResponse *r = (NSHTTPURLResponse*) response;
	NSDictionary *headers = [r allHeaderFields];
	if (headers){
		if ([headers objectForKey: @"Content-Range"]) {
			NSString *contentRange = [headers objectForKey: @"Content-Range"];
			NSRange range = [contentRange rangeOfString: @"/"];
			NSString *totalBytesCount = [contentRange substringFromIndex: range.location + 1];
			expectedBytes = [totalBytesCount floatValue];
		} else if ([headers objectForKey: @"Content-Length"]) {
			expectedBytes = [[headers objectForKey: @"Content-Length"] floatValue];
		} else expectedBytes = -1;
		
		if ([@"Identity" isEqualToString: [headers objectForKey: @"Transfer-Encoding"]]) {
			expectedBytes = bytesReceived;
		}
	}    
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    
	if (!operationBreaked) {
        
		[self.receivedData appendData:data];
		
		float receivedLen = [data length];
		bytesReceived = (bytesReceived + receivedLen);
		
		if(expectedBytes != NSURLResponseUnknownLength) {
			percentComplete = ((bytesReceived/(float)expectedBytes)*100);
            
            NSArray *objectSend = [NSArray arrayWithObjects:[NSNumber numberWithInt:percentComplete], _downloadOperationId, nil];            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"downloadingProcessNotification" object:objectSend];
		}
        
	} else {
		[connection cancel];
		DLog(@" STOP !!!!  Receiving data was stoped");
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    [super connectionDidFinishLoading:connection];
    
	operationFinished = YES;
    NSFileManager *fileManager = [NSFileManager defaultManager];
	[fileManager createFileAtPath:[FilePathUtility constructPathWidthDownloadId:_downloadOperationId andUrl:[_url relativeString]] contents:self.receivedData attributes:nil];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [super connection:connection didFailWithError:error];
    
    if ([UIAppDelegate backgroundSupported]) {
        if (bgTaskDownloadChapter != UIBackgroundTaskInvalid) {
            DLog(@"bgTaskDownloadChapter - end");
            [[UIApplication sharedApplication] endBackgroundTask:bgTaskDownloadChapter];
            bgTaskDownloadChapter = UIBackgroundTaskInvalid;
        }
    }
    
    DLog(@"Error download");
}


@end
