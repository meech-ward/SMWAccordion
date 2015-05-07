//
//  SMWAccordianTableView.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableView.h"

static const float SMWAccordionTableViewAnimationDuration = 0.3;

@interface SMWAccordionTableView() <UITableViewDelegate>

@property (strong, nonatomic) SMWAccordionTableViewDelegateObject *delegateObject;

/*
 The currently selected cell.
 */
@property (strong, nonatomic) UITableViewCell *currentCell;

/*
 The current content view being shown
 This value is nil if no cells are selected.
 */
@property (strong, nonatomic) UIView *currentContentView;

/*
 The index paths of all the cells that are removed from screen when displaying the content view.
 Keeps track of the index paths of the cells that are removed from the accordion view when they go off screen to make room for the content view.
 One use of this is to determine if the last cell that was dealocated was from the top or the bottom of the table view.
 */
@property (strong, nonatomic) NSMutableDictionary *removedIndexPaths;

/*
 The content size of the accordion view before any content views are shown.
 Keeps track of the original contnet size, before any accordion content views are shown.
 This value is the same as self.contentSize when the accordion is closed.
 */
@property (nonatomic) CGSize originContentSize;

/*
 A Boolean value that is keeps track of whether the accordion is open.
 This value is true when a cell is selected and the content view is being show. This value is false when a cell is not selected and no content view is shown.
 */
@property (nonatomic) BOOL accordionIsOpen;

@end

@implementation SMWAccordionTableView

// Tell the compiler that UITableView will provide the implementation for the dataSource and delegate
// UITableView will 'host' these properties and SMWAccordionTableView will use them
@dynamic dataSource, delegate;

#pragma mark - Setup

- (id)init {
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib {
    [self setup];
    [super awakeFromNib];
}

- (void)setup {
    // Setup default values
    self.shouldAnimate = YES;
    
    // Initaialize objects
    self.removedIndexPaths = [[NSMutableDictionary alloc] init];
    
    // Custom delegate object
    [self setupCustomDelegateObject];
}

#pragma mark - Delegate

- (void)setupCustomDelegateObject {
    // Setup a "Hacky" way of using delegate methods while allowing the
    // developer to use the standard table view delegate methods for this class
    [self.delegateObject setAccordionView:self];
    [super setDelegate:self.delegateObject];
}

- (void)setDelegate:(id<SMWAccordionTableViewDelegate>)delegate {
    self.delegateObject.delegate = delegate;
}

- (SMWAccordionTableViewDelegateObject *)delegateObject {
    if (!_delegateObject) {
        _delegateObject = [[SMWAccordionTableViewDelegateObject alloc] init];
    }
    return _delegateObject;
}

#pragma mark - Touches

// Override the touches began and do nothing
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the current content view height
    float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
    
    // Get the currently selected cell
    self.currentCell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
    
    // Get the current location of the user's touch
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint selectedLocation = [touch locationInView:self.currentCell];
    
    // Check if the user selected a cell, or if the user touched the content view
    if (self.currentCell && selectedLocation.y > CGRectGetHeight(self.currentCell.frame) && self.accordionIsOpen) {
        if (selectedLocation.y < self.currentCell.frame.size.height+contentHeight) {
            // Tapped the content view
            // Do nothing
            return;
        }
        
        // Touch is below the content view
        // Compensate for the content view's height
        location = CGPointMake(location.x, location.y - contentHeight);
    }
    
    // Get the index path from the location
    NSIndexPath *indexPath = [super indexPathForRowAtPoint:location];
    if (!indexPath) {
        return;
    }
    
    // Get cell from the index path
    UITableViewCell *nextCell = [self cellForRowAtIndexPath:indexPath];
    
    // Show/Hide the content
    if (!self.accordionIsOpen) {
        
        // Select the row at the current index path
        [self selectRowAtIndexPath:indexPath animated:self.shouldAnimate scrollPosition:UITableViewScrollPositionNone];
        
    } else if (self.accordionIsOpen) {
        
        // The accordion is currently open, self.currentCell is selected
        if (self.currentCell == nextCell) {
            
            // The selected cell was just tapped, close the content view
            [self deselectRowAtIndexPath:indexPath animated:self.shouldAnimate];
            
        } else {
            
            // A new cell was tapped, Close the old content view
            [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:self.shouldAnimate completion:^(BOOL finished) {
                
                // Select the row at the current index path
                [self selectRowAtIndexPath:indexPath animated:self.shouldAnimate scrollPosition:UITableViewScrollPositionNone];
            }];
        }
    }
}

#pragma mark - Content View

- (void)updateCurrentContentViewBelowCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    // Remove current view
    [self removeContentView];
    
    // Get the new content view using the data source
    if ((self.currentContentView = [self.dataSource accordionView:self contentViewForRowAtIndexPath:indexPath])) {
        
        // Insert with new frame
        [self insertSubview:self.currentContentView atIndex:1];
        self.currentContentView.layer.zPosition = -1;
        self.currentContentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y+cell.frame.size.height, self.currentContentView.bounds.size.width, self.currentContentView.bounds.size.height);
    }
}

- (void)removeContentView {
    // If there is a current content view, remove it
    if (self.currentContentView) {
        [self.currentContentView removeFromSuperview];
        self.currentContentView = nil;
    }
}

#pragma mark - Move Cells


- (void)adjustVisibleCellsUnderCell:(UITableViewCell *)cell frame:(CGRect (^)(UITableViewCell *currentCell, UITableViewCell *previousCell))getFrame {
    // Loop through all the visible cells, top to bottom, and move all the cells below the selected cell down to make room for the content view
    // Create a variable that is true when the loop passes the currently selected cell
    BOOL passed = NO;
    UITableViewCell *previousCell;
    
    // Loop through the cells and move as needed
    for (UITableViewCell *visCell in self.visibleCells) {
        if (passed) {
            // The loop has passed the selected cell so move the current cell down
            visCell.frame = getFrame(visCell, previousCell);
        } else if (visCell == cell) {
            // The current cell is the selected cell
            // The next itteration of this loop will move on to the next cell
            passed = YES;
        }
        previousCell = visCell;
    }
}

- (void)adjustVisibleCellsUnderCell:(UITableViewCell *)cell y:(float (^)(UITableViewCell *currentCell, UITableViewCell *previousCell))getY {
    // Similar to adjustVisibleCellsUnderCell:frame but uses some pre defined x, width, and height values
    [self adjustVisibleCellsUnderCell:cell frame:^CGRect(UITableViewCell *currentCell, UITableViewCell *previousCell) {
        return CGRectMake(CGRectGetMinX(currentCell.frame), getY(currentCell, previousCell), CGRectGetWidth(currentCell.bounds), CGRectGetHeight(currentCell.bounds));
    }];
}

- (void)animateContentViewMaskFromPath:(UIBezierPath *)fromPath toPath:(UIBezierPath *)toPath completion:(void(^)(void))completion {
    
    // Add a mask to the view if there are not enough cells to create the animation
    CAShapeLayer *mask = [CAShapeLayer layer];
    mask.frame = CGRectMake(0, 0, CGRectGetWidth(self.currentContentView.bounds), CGRectGetHeight(self.currentContentView.bounds));
    [self.currentContentView.layer setMask:mask];
    
    // Use a transaction to animate the mask
    [CATransaction begin];
    [CATransaction setAnimationDuration:SMWAccordionTableViewAnimationDuration];
    [CATransaction setAnimationTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    // Set the animation completion block
    if (completion) {
        [CATransaction setCompletionBlock:completion];
    }
    
    // Create a path animation for the mask
    CABasicAnimation *pathAnimation = [CABasicAnimation animationWithKeyPath:@"path"];
    pathAnimation.fromValue = (__bridge id)fromPath.CGPath;
    pathAnimation.toValue = (__bridge id)toPath.CGPath;
    
    // Stop the animation from removing itself, it will be removed after the cells animations are complete
    [pathAnimation setFillMode:kCAFillModeBoth];
    [pathAnimation setRemovedOnCompletion:NO];
    pathAnimation.delegate = self;
    
    // Add the animation to the mask
    [mask addAnimation:pathAnimation forKey:nil];
    
    // Commit the animation
    [CATransaction commit];
}

- (void)moveCells:(void(^)(void))moveCells animateMask:(void(^)(void (^)(void)))animateMask cellsMoved:(void(^)(BOOL))cellsMoved animated:(BOOL)animated cell:(UITableViewCell *)cell {
    
    // Determine if the move is supposed to be animated
    if (!animated) {
        // Move the cells without animating
        moveCells();
        cellsMoved(YES);
        return;
    }

    // Animate the content view mask
    if (![self cellsFillScreen]) {
        // There are not enough cells to fill the table view
        // A mask has to be used to animate the content view
        
        // Check if the last cell was selected
        if (cell == [self.visibleCells lastObject]) {
            // Last Cell
            // No cells below to move
            // Animate the mask, then call the cells moved block
            animateMask(^{cellsMoved(YES);});
            return;
        } else {
            // Not last cell
            // Animate the mask and move the cells
            animateMask(nil);
        }
    }
    
    // Move the cells with an animation
    [UIView animateWithDuration:SMWAccordionTableViewAnimationDuration delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:moveCells completion:cellsMoved];
}

#pragma mark Close

- (void)closeAccordionAnimated:(BOOL)animated {
    [self deselectRowAtIndexPath:[self indexPathForCell:self.currentCell] animated:animated];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    [self deselectRowAtIndexPath:indexPath animated:animated completion:nil];
}

- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    // Move the cells back to their original positions (close the accordion)
    [self moveCellsBackToSelectedCell:self.currentCell animated:animated completion:^(BOOL finished) {

        // Desect the current row
        [super deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:animated];
        
        // Remove the content view
        [self removeContentView];
        
        // Nil the current cell
        self.currentCell = nil;
        
        // Perform the passed in completion block
        if (completion) completion(finished);

    }];
}

- (void)moveCellsBackToSelectedCell:(UITableViewCell *)cell animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    
    // Delegate
    [self.delegate accordionViewWillClose:self];
    
    void (^animateMask)(void (^)(void)) = ^(void (^completion)(void)) {
        // Animate the content view mask
        [self animateContentViewMaskFromPath:[self contentOpenPath] toPath:[self contentClosePath] completion:completion];
    };
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
        
        // Move the table cells
        [self adjustVisibleCellsUnderCell:cell y:^float(UITableViewCell *currentCell, UITableViewCell *previousCell) {
            return CGRectGetMaxY(previousCell.frame);
        }];
        
        // Adjust the content size to compensate for the moving cells
        self.contentSize = self.originContentSize;
    };
    
    // Create a block to fire after the cells have been moved
    void (^cellsMoved)(BOOL) = ^(BOOL finished) {
        // Finished updating cells
        [self endUpdates];
        
        // Update properties
        self.accordionIsOpen = NO;
        
        // If a mask was used on teh current content view, remove it
        [self removeContentMask];

        // Call the completion block
        if (completion) completion(finished);
        // Delegate
        [self.delegate accordionViewDidClose:self];
    };
    
    // Move the cells
    [self beginUpdates]; // Start updating cells
    [self moveCells:moveCells animateMask:animateMask cellsMoved:cellsMoved animated:animated cell:cell];
}

#pragma mark Open

- (void)selectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated scrollPosition:(UITableViewScrollPosition)scrollPosition {
    // The accordion is currently closed, no cells selected
    // Open the accordion and show the content view
    
    // Get cell from the index path
    UITableViewCell *cell = [self cellForRowAtIndexPath:indexPath];
    
    // Update the current content view
    [self updateCurrentContentViewBelowCell:cell withIndexPath:indexPath];
    float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
    
    // Show the content view
    // Move the cells to show the content view
    [self moveCellsFromSelectedCell:cell distance:contentHeight animated:animated completion:nil];
    
    // Call super to select the cell
    [super selectRowAtIndexPath:indexPath animated:animated scrollPosition:UITableViewScrollPositionNone];
    
    // Set the current cell
    self.currentCell = cell;
}

- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    
    // Delegate
    [self.delegate accordionViewWillOpen:self];
    
    void (^animateMask)(void (^)(void)) = ^(void (^completion)(void)){
        // Animate the content view mask
        [self animateContentViewMaskFromPath:[self contentClosePath] toPath:[self contentOpenPath] completion:completion];
    };
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
        
        // Move the table cells
        [self adjustVisibleCellsUnderCell:cell y:^float(UITableViewCell *currentCell, UITableViewCell *previousCell) {
            return CGRectGetMinY(currentCell.frame)+distance;
        }];
        
        // Adjust the content size
        self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height+distance);
    };
    
    // TODO adjust header and footer to move with cells
    
    // Create a block to adjust the content offset and compensate if the view doesn't fit on screen (if the last cell is tapped, the view would be below the table and not be seen)
    void (^adjustContentOffset)(void) = ^{
        // Check if the content view fits on screen
        float contentEndY = self.currentContentView.bounds.size.height+self.currentContentView.frame.origin.y-self.contentOffset.y;
        if (contentEndY > self.bounds.size.height) {
            // Doesn't fit on screen, Move the screen
            float difference = contentEndY - self.bounds.size.height;
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y+difference) animated:animated];
        }
    };
    
    // Create a block to fire after the cells have been moved
    void (^cellsMoved)(BOOL) = ^(BOOL finished) {
        // Adjust the content offset
        adjustContentOffset();
        
        // If a mask was used on the current content view, remove it
        [self removeContentMask];
        
        // Call the completion block
        if (completion) completion(finished);
        // Delegate
        [self.delegate accordionViewDidOpen:self];
    };
    
    // Save the current (normal) content size
    self.originContentSize = self.contentSize;
    
    // Move the cells
    self.accordionIsOpen = YES;
    [self moveCells:moveCells animateMask:animateMask cellsMoved:cellsMoved animated:animated cell:cell];
}

#pragma mark - TableView delegate

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.currentCell) {
        // Get the index path of the currently selected row
        NSIndexPath *selectedIndexPath = [self indexPathForCell:self.currentCell];
        // Check if the new cell is below the selected one
        if (selectedIndexPath.row < indexPath.row) {
            // Check if the content view is currently open
            if (self.accordionIsOpen) {
                cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y+self.currentContentView.bounds.size.height, cell.bounds.size.width, cell.bounds.size.height);
            }
        }
    }
}

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    // Check if the cell was dismissed off the top or bottom
    NSIndexPath *lastPath = [self.removedIndexPaths objectForKey:[NSNumber numberWithInteger:indexPath.section]];
    if (!lastPath) lastPath = [NSIndexPath indexPathForRow:-1 inSection:indexPath.section];
    
    // Check if the cell was off of the top or the bottom
    BOOL offTheTop = NO;
    if (lastPath.row == indexPath.row+1 || (lastPath.row < indexPath.row-1)) {
        // Removed from the bottom
        offTheTop = NO;
    } else if (lastPath.row == indexPath.row-1 || (lastPath.row > indexPath.row+1)) {
        // Removed from the top
        offTheTop = YES;
    }
    
    // Check if the current selected cell is leaving the screen
    if (cell == self.currentCell) {
        
        // Stop displaying content view
        self.accordionIsOpen = NO;
        
        // Deselect the row
        [self deselectRowAtIndexPath:indexPath animated:self.shouldAnimate completion:^(BOOL finished) {
            
        }];
    }
    
    // Set the last index path
    [self.removedIndexPaths setObject:indexPath forKey:[NSNumber numberWithInteger:indexPath.section]];
}

#pragma mark - Utility 

- (BOOL)cellsFillScreen {
    // Check if the table view is full of cells
    if (CGRectGetHeight(self.bounds) < self.visibleCells.count*self.rowHeight) {
        NSLog(@"cells do fill screen");
        return true;
    }
    NSLog(@"cells do not fill screen");
    return false;
}

- (void)removeContentMask {
    // If a mask was used on the current content view, remove it
    if (self.currentContentView && self.currentContentView.layer.mask) {
        [CATransaction begin];
        [CATransaction setDisableActions:YES];
        [self.currentContentView.layer setMask:nil];
        [CATransaction commit];
    }
}

// The Paths that are used to mask the content view
- (UIBezierPath *)contentClosePath {
    return [UIBezierPath bezierPathWithRect:CGRectMake(0.0, 0.0, CGRectGetWidth(self.currentContentView.bounds), 0.0)];
}
- (UIBezierPath *)contentOpenPath {
    return [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, CGRectGetWidth(self.currentContentView.bounds), CGRectGetHeight(self.currentContentView.bounds))];
}

@end
