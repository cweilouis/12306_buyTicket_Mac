//
//  OSXPullToRefreshScrollView.h
//  OSXPullToRefresh
//
//  Created by surrender on 14-1-10.
//  Copyright (c) 2014年 surrender. All rights reserved.
//

#import <Cocoa/Cocoa.h>

typedef void(^startLoadinBlock)(void);

@interface OSXPullToRefreshScrollView : NSScrollView
@property (readonly) NSView *headerView;
@property (readonly) NSTextField *textField;
@property (readonly) NSProgressIndicator *indicator;
@property (readonly) BOOL isRefreshing;
@property (nonatomic,copy)startLoadinBlock startLoadinBlock;

- (void)beginLoadingWithStartLoadinBlock:(startLoadinBlock)startLoadinBlock;

- (void)startLoading;

- (void)stopLoading;
@end
