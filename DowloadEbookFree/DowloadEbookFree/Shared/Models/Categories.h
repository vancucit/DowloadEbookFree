//
//  Categories.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


@class Download;

@interface Categories : NSManagedObject

@property (nonatomic, strong) NSNumber * categoryId;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSSet *hasDownload;

+ (Categories *)categoryWithName:(NSString *)name;

+ (NSNumber *)maxCategoriesId;

@end

@interface Categories (CoreDataGeneratedAccessors)

- (void)addHasDownloadObject:(Download *)value;
- (void)removeHasDownloadObject:(Download *)value;
- (void)addHasDownload:(NSSet *)values;
- (void)removeHasDownload:(NSSet *)values;

@end
