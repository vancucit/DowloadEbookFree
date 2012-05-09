//
//  ViewBookmarkViewController.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "BookmarkObject.h"

@interface ViewBookmarkViewController : UITableViewController<UITextFieldDelegate> {
@private
    id _delegate;
    UIBarButtonItem *_doneButtonItem;
    NSMutableArray *_bookmarksArray;
}

@property (retain,nonatomic) id delegate;
@property (retain,nonatomic) UIBarButtonItem *doneButtonItem;
@property (retain,nonatomic) BookmarkObject *bookmarkNew;

- (void)setBookmark:(NSString *)aName url:(NSURL *)aURL;
- (void)doneButtonAction;
- (void)saveBookmarks;
@end

@protocol ViewBookmarkDelegate <NSObject>
- (void)openThisURL:(NSURL *)url;
- (void)dismissViewBookmMarkViewController:(ViewBookmarkViewController *)viewController;
@end
