//
//  Categories.m
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "Categories.h"
#import "Download.h"


@implementation Categories

@dynamic categoryId;
@dynamic name;
@dynamic hasDownload;

+ (NSNumber *)maxCategoriesId {
    Categories *category  = [self findFirstWithPredicate:nil sortedBy:@"categoryId" ascending:NO andRetrieveAttributes:[NSArray arrayWithObject:@"categoryId"]];
    
    int categoryId = 1;
    if (category) {
        categoryId = [category.categoryId intValue] + 1;
    }
    
    return [NSNumber numberWithInt:categoryId];
}


+ (Categories *)categoryWithName:(NSString *)name {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"name = '%@'", name]];
    
    return [Categories findFirstWithPredicate:predicate];
}


@end
