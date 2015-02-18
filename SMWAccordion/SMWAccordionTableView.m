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

// The currently selected cell
@property (strong, nonatomic) UITableViewCell *currentCell;
// The current content view being show, nil if no cells are selected
@property (strong, nonatomic) UIView *currentContentView;

// Keeps track of the index paths of the cells that are removed from the table view when they go off screen
// One use of this is to determine if the last cell that was dealocated was from the top or the bottom of the table view
@property (strong, nonatomic) NSMutableDictionary *removedIndexPaths;

// Keeps track of the original contnet size, before any accordion content views are added
// self.contentSize has to return to this value when the accordion is closed
@property (nonatomic) CGSize originContentSize;

// Keeps track of whether the accordion is open (a cell is selected)
@property (nonatomic) BOOL accordionIsOpen;

@end

@implementation SMWAccordionTableView

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
    if (selectedLocation.y > self.currentCell.frame.size.height && self.accordionIsOpen) {
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
    
    // Set the current cell
    self.currentCell = nextCell;
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

#pragma mark Close

- (void)closeAccordionAnimated:(BOOL)aniamted {
    [self deselectRowAtIndexPath:[self indexPathForCell:self.currentCell] animated:aniamted];
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
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
        // Loop through all the visible cells, top to bottom, and move all the cells below the selected cell down to make room for the content view
        // Create a variable that is true when the loop passes the currently selected cell
        BOOL passed = NO;
        UITableViewCell *lastCell;
        
        // Loop through the cells and move as needed
        for (UITableViewCell *visCell in self.visibleCells) {
            if (passed) {
                // The loop has passed the selected cell so move the current cell down
                visCell.frame = CGRectMake(visCell.frame.origin.x, lastCell.frame.origin.y+lastCell.frame.size.height, visCell.frame.size.width, visCell.frame.size.height);
            } else if (visCell == cell) {
                // The current cell is the selected cell
                // The next itteration of this loop will move on to the next cell
                passed = YES;
            }
            lastCell = visCell;
        }
        // Adjust the content size to compensate for the moving cells
        self.contentSize = self.originContentSize;
    };
    
    void (^cellsMoved)(BOOL) = ^(BOOL finished) {
        // Finished updating cells
        [self endUpdates];
        
        // Update properties
        self.accordionIsOpen = NO;
        
        // Call the completion block
        if (completion) completion(finished);
        
        // Delegate
        [self.delegate accordionViewDidClose:self];
    };
    
    // Move the cells
    [self beginUpdates]; // Start updating cells
    if (animated) {
        [UIView animateWithDuration:SMWAccordionTableViewAnimationDuration animations:moveCells completion:cellsMoved];
    } else {
        // Move the cells without animating
        moveCells();
        cellsMoved(YES);
    }
    
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
}

- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    
    // Delegate
    [self.delegate accordionViewWillOpen:self];
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
        //
        BOOL passed = NO;
        // Loop through the cells and move as needed
        for (UITableViewCell *visCell in self.visibleCells) {
            if (passed) {
                visCell.frame = CGRectMake(visCell.frame.origin.x, visCell.frame.origin.y+distance, visCell.frame.size.width, visCell.frame.size.height);
            } else {
                if (visCell == cell) {
                    passed = YES;
                }
            }
        }
    };
    
    // Todo adjust header and footer to move with cells
    
    void (^adjustContentOffset)(void) = ^{
        // Check if the content view fits on screen
        float contentEndY = self.currentContentView.bounds.size.height+self.currentContentView.frame.origin.y-self.contentOffset.y;
        if (contentEndY > self.bounds.size.height) {
            // Doesn't fit on screen
            float difference = contentEndY - self.bounds.size.height;
            // Move the screen
            [self setContentOffset:CGPointMake(self.contentOffset.x, self.contentOffset.y+difference) animated:animated];
        }
        self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height+distance);
    };
    
    self.originContentSize = self.contentSize;
    
    // Move the cells
    self.accordionIsOpen = YES;
    if (animated) {
        [UIView animateWithDuration:SMWAccordionTableViewAnimationDuration animations:^{
            // Adjust the content size
            self.contentSize = CGSizeMake(self.contentSize.width, self.contentSize.height+distance);
            // Move the cells
            moveCells();
        } completion:^(BOOL finished) {
            // Adjust the content offset
            adjustContentOffset();
            if (completion) completion(finished);
            // Delegate
            [self.delegate accordionViewDidOpen:self];
        }];
    } else {
        // Move the cells
        moveCells();
        // Adjust the content offset
        adjustContentOffset();
        // Completiom
        self.accordionIsOpen = YES;
        if (completion) completion(YES);
        // Delegate
        [self.delegate accordionViewDidOpen:self];
    }
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

@end
