//
//  SMWAccordionTableViewDelegateObject.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

// This object manages the table view delegate methods and the accordion specific delegate methods
//
// The necessary table view methods are passed to the accrodion, and all delegate methods are passed,
// as normal, to the accoridion's delegate as if it were a normal UITableView
//

@import UIKit;

@class SMWAccordionTableView;

NS_ASSUME_NONNULL_BEGIN

/**
 The delegate of an SMWAccordionTableViewDelegate object must adopt the SMWAccordionTableViewDelegate protocol.
 */
@protocol SMWAccordionTableViewDelegate <NSObject, UIScrollViewDelegate, UITableViewDelegate>

@optional


/// @name Managing Opening and Closing

/**
 Tells the delegate that the accordionView is about to close.
 
 This method is called when a user deselects a row.
 @param accordionView The SMWAccordionView object informing the delegate about the impending close.
 */
- (void)accordionViewWillClose:(SMWAccordionTableView *)accordionView __deprecated;

/**
 Tells the delegate that the accordionView is about to close.
 
 This method is called when a user deselects a row.
 @param accordionView The SMWAccordionView object informing the delegate about the impending close.
 @param cell The cell that is currently open and will close.
 @param indexPath An index path locating the row in the accordion view.
 */
- (void)accordionView:(SMWAccordionTableView *)accordionView willCloseCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Tells the delegate that the accordionView is now closed.
 
 This method is called after [accordionViewWillClose:].
 @param accordionView The SMWAccordionView object informing the delegate about being closed.
 */
- (void)accordionViewDidClose:(SMWAccordionTableView *)accordionView __deprecated;

/**
 Tells the delegate that the accordionView is now closed.
 
 This method is called after [accordionViewWillClose:].
 @param accordionView The SMWAccordionView object informing the delegate about being closed.
 @param cell The cell that was open and just finished closing.
 @param indexPath An index path locating the row in the accordion view.
 */
- (void)accordionView:(SMWAccordionTableView *)accordionView didCloseCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Tells the delegate that the accordionView is about to open.
 
 This method is called when a user selects a row.
 @param accordionView The SMWAccordionView object informing the delegate about the impending open.
 */
- (void)accordionViewWillOpen:(SMWAccordionTableView *)accordionView __deprecated;

/**
 Tells the delegate that the accordionView is about to open.
 
 This method is called when a user selects a row.
 @param accordionView The SMWAccordionView object informing the delegate about the impending open.
 @param cell The cell that is about to be opened.
 @param indexPath An index path locating the row in the accordion view.
 */
- (void)accordionView:(SMWAccordionTableView *)accordionView willOpenCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

/**
 Tells the delegate that the accordionView is now open.
 
 This method is called after [accordionViewWillOpen:].
 @param accordionView The SMWAccordionView object informing the delegate about being open.
 */
- (void)accordionViewDidOpen:(SMWAccordionTableView *)accordionView __deprecated;

/**
 Tells the delegate that the accordionView is now open.
 
 This method is called after [accordionViewWillOpen:].
 @param accordionView The SMWAccordionView object informing the delegate about being open.
 @param cell The cell that was just opened.
 @param indexPath An index path locating the row in the accordion view.
 */
- (void)accordionView:(SMWAccordionTableView *)accordionView didOpenCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

@end

/*
 `SMWAccordionTableViewDelegateObject` is an `NSObject` that is used to manage all `SMWAccordionTableViewDelegate` delegate methods and forward all `UITableViewDelegate` methods to the `SMWAccordionTableViewDelegate`. It is also responsible for passing on any necessary `UITableViewDelegate` methods to the `SMWAccordionTableView`
 */
@interface SMWAccordionTableViewDelegateObject : NSObject <SMWAccordionTableViewDelegate>

/*
 The object that acts as the delegate of the accordion view delegate object.
 */
@property (weak, nonatomic) id<SMWAccordionTableViewDelegate>delegate;

/*
 The accordion view that gets any needed `UITableViewDelegate` methods sent to it.
 */
@property (weak, nonatomic) SMWAccordionTableView<UITableViewDelegate> *accordionView;

@end

NS_ASSUME_NONNULL_END