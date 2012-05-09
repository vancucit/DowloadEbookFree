//
//  AddBookmarkViewController.h
//  iMusicPro
//
//  Created by Hung Tran on 14/12/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//


#import <UIKit/UIKit.h>
#import "BookmarkObject.h"

@interface AddBookmarkViewController : UITableViewController<UITextFieldDelegate, UIActionSheetDelegate> {
    id _delegate;
    NSMutableArray *_bookmarksArray;
    UITextField *_nameTextField;
}

@property (strong,nonatomic) id delegate;
@property (strong,nonatomic) BookmarkObject *bookmarkNew;

- (void)setBookmark:(NSString *)aName url:(NSURL *)aURL;
@end

@protocol AddBookmarkDelegate <NSObject>
- (void)dismissAddBookmMarkViewController:(AddBookmarkViewController *)viewController;
@end
