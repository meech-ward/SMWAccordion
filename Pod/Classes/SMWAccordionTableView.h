//
//  SMWAccordianTableView.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

@import UIKit;


//
// Delegate
//
#import "SMWAccordionTableViewDelegateObject.h"

NS_ASSUME_NONNULL_BEGIN

/**
 The `SMWAccordionTableViewDataSource` protocol is adopted by an object that mediates the application’s data model for an SMWAccordion object. The data source provides the accordion-view object with the information it needs to construct and modify an accordion view.
 */
@protocol SMWAccordionTableViewDataSource <NSObject, UITableViewDataSource>

/// @name Configuring a Content View

/**
 Asks the data source for a view to insert under the selected row of the accordionView.
 
 The view returned by this function will be displayed within the accordion. This view should have the same width as the accordion but be smaller in height so it doesn't take up the whole screen and force the accordion to close.
 Using a maximum height of half the size of the accordion view is prefered. If the data does not fit within these bounds, a scrollview can be added to the content view.
 @param accordionView The SMWAccordionView object requesting the view.
 @param indexPath The index path locating the selected row in the accordionView.
 @return The UIView that will be displayed inside the accordion.
 */
- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


/**
 `SMWAccordionTableView` is a subclass of `UITableView` that allows you to display small amounts of content inline using collapsible `UITableViewCell`.
 */
@interface SMWAccordionTableView : UITableView


/// @name Configuring the accordion view

/**
 Used to determine whether the accordion will animate up and down to show the content view.
 */
@property (nonatomic) BOOL shouldAnimate;


/// @name Manage the content view

/**
 The current content view being show.
 
 This is the same view that is returned by the 'contentViewForRowAtIndexPath' data source method.
 This value will be nil if no cells are selected.
 */
@property (strong, nonatomic, readonly, nullable) UIView *currentContentView;


/// @name Manually close the accordion view

/**
 Deselects the currently selected row, and closes the accordion.
 
 Calling this method provides the same functionality as [deselectRowAtIndexPath:animated:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/deselectRowAtIndexPath:animated:) if you passed in the currently selected row's index path.
 @param animated YES to animate the deselection and closing transition; NO to make the transition immediate.
 */
- (void)closeAccordionAnimated:(BOOL)animated;

/**
 Deselects a given row identified by index path, and closes the accordion.
 
 Calling this method provides the same functionality as [deselectRowAtIndexPath:animated:](https://developer.apple.com/library/ios/documentation/UIKit/Reference/UITableView_Class/index.html#//apple_ref/occ/instm/UITableView/deselectRowAtIndexPath:animated:) with the additional option of passing in a completion block.
 @param indexPath An index path identifying a row in the table view.
 @param animated YES to animate the deselection and closing transition; NO to make the transition immediate.
 @param completion A block object to be executed when the transition ends. This block has no return value and takes a single Boolean argument that indicates whether or not the transition actually finished before the completion handler was called. This parameter may be NULL.
 */
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completion:(nullable void(^)(BOOL finished))completion;


/// @name Managing the Delegate and the Data Source

/**
 The object that acts as the data source of the accordion view.
 
 The data source must adopt the SMWAccordionTableViewDataSource protocol. The data source is not retained.
 */
@property (nonatomic, assign) id <SMWAccordionTableViewDataSource>dataSource;
/**
 The object that acts as the delegate of the accordion view
 
 The delegate must adopt the SMWAccordionTableViewDelegate protocol. The delegate is not retained.
 */
@property (nonatomic, assign) id <SMWAccordionTableViewDelegate>delegate;

@end

NS_ASSUME_NONNULL_END

