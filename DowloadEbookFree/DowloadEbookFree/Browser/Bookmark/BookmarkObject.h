//
//  BookmarkObject.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@interface BookmarkObject : NSObject <NSCoding> {
    NSString *_name;
    NSURL *_url;
}
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSURL *url;

- (id) initWithName:(NSString *)name andURL:(NSURL *)url;

@end
