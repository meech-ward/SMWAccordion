//
//  SMWAccordianTableView.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableView.h"

@interface SMWAccordionTableView()

@property (strong, nonatomic) SMWAccordionTableViewDelegateObject *delegateObject;
//@property (strong, nonatomic) SMWAccordionTableViewDataSourceObject *dataSourceObject;

@property (strong, nonatomic) UITableViewCell *currentCell;

@property (strong, nonatomic) NSMutableDictionary *removedIndexPaths;

@property (nonatomic) CGSize originContentSize;

@property (nonatomic) BOOL accordionIsOpen;

@end

@implementation SMWAccordionTableView

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
    self.shouldAnimate = YES;
    self.removedIndexPaths = [[NSMutableDictionary alloc] init];
    
    // Custom delegate object
    [self.delegateObject setAccordionView:self];
    [super setDelegate:self.delegateObject];
    
    // Custom datasource object
//    [self.dataSourceObject setAccordionView:self];
//    [super setDataSource:self.dataSourceObject];
}

#pragma mark - Delegate / Data Source

- (void)setRealDelegate:(id)delegate {
    [super setDelegate:delegate];
}

//- (void)setDataSource:(id<SMWAccordionTableViewDataSource>)dataSource {
//    self.dataSourceObject.dataSource = dataSource;
//}
//- (id<SMWAccordionTableViewDataSource>)dataSource {
//    return self.dataSourceObject.dataSource;
//}
- (void)setDelegate:(id<SMWAccordionTableViewDelegate>)delegate {
    self.delegateObject.delegate = delegate;
}
//- (id<SMWAccordionTableViewDelegate>)delegate {
//    return self.delegateObject.delegate;
//}

//- (SMWAccordionTableViewDataSourceObject *)dataSourceObject {
//    if (!_dataSourceObject) {
//        _dataSourceObject = [[SMWAccordionTableViewDataSourceObject alloc] init];
//    }
//    return _dataSourceObject;
//}

- (SMWAccordionTableViewDelegateObject *)delegateObject {
    if (!_delegateObject) {
        _delegateObject = [[SMWAccordionTableViewDelegateObject alloc] init];
    }
    return _delegateObject;
}

#pragma mark - Touches

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    // Get the current content view height
    float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
    
    // Get the currently selected cell
    self.currentCell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
    
    // Get the current location
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint selectedLocation = [touch locationInView:self.currentCell];
    
    //
    if (selectedLocation.y > self.currentCell.frame.size.height && self.accordionIsOpen) {
        if (selectedLocation.y < self.currentCell.frame.size.height+contentHeight) {
            // Tapped the content view
            return;
        }
        location = CGPointMake(location.x, location.y - contentHeight);
    }
    
    // Get the index path from the location
    NSIndexPath *indexPath = [super indexPathForRowAtPoint:location];
    
    // Get cell for the index path
    UITableViewCell *nextCell = [self cellForRowAtIndexPath:indexPath];
    
    // Show/Hide the content
    if (!self.accordionIsOpen) {
        
        // Update the current content view
        [self updateCurrentContentViewBelowCell:nextCell withIndexPath:indexPath];
        float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
        // Show the content view
        [self moveCellsFromSelectedCell:nextCell distance:contentHeight animated:self.shouldAnimate completion:nil];
        // Use the select row at index path function to show the current row instead of letting touches ended do it's default thing
        [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
        
    } else if (self.accordionIsOpen) {
        if (self.currentCell == nextCell) {
            
            // The selected cell was just tapped, close the content view
            [self moveCellsBackToSelectedCell:self.currentCell animated:self.shouldAnimate completion:^(BOOL finished) {
                // Desect the current row
                [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:YES];
                // Remove the content view
                [self removeContentView];
            }];
            
        } else {
            
            // A new cell was tapped, Close the old content view
            [self moveCellsBackToSelectedCell:self.currentCell animated:self.shouldAnimate completion:^(BOOL finished) {
                // Deselect the currently selected row
                [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
                
                // Update the current content view
                [self updateCurrentContentViewBelowCell:nextCell withIndexPath:indexPath];
                float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
                
                // Show the new content view
                [self moveCellsFromSelectedCell:nextCell distance:contentHeight animated:self.shouldAnimate completion:nil];
                
                // Update the selected Cell
                // Use the select row at index path function to show the current row instead of letting touches ended do it's default thing
                [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
                
            }];
        }
    }
    
    //
    // Modify the frame of the content view
    [self insertSubview:self.currentContentView atIndex:1]; // Set to one so that user interation is enabled
    self.currentContentView.layer.zPosition = -1; // Set to minus one so that it appears under the cells
//    [self addSubview:self.currentContentView];
    
    // Set the current cell
    self.currentCell = nextCell;
}

#pragma mark - Content View

- (void)updateCurrentContentViewBelowCell:(UITableViewCell *)cell withIndexPath:(NSIndexPath *)indexPath{
    // Remove current view
    [self removeContentView];
    
    // Get the new content view
    self.currentContentView = [self.dataSource accordionView:self contentViewForRowAtIndexPath:indexPath];
    if (self.currentContentView) {
        // Insert with new frame
        [self insertSubview:self.currentContentView atIndex:1];
        self.currentContentView.layer.zPosition = -1;
        self.currentContentView.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y+cell.frame.size.height, self.currentContentView.bounds.size.width, self.currentContentView.bounds.size.height);
        
    }
}

- (void)removeContentView {
    if (self.currentContentView) {
        [self.currentContentView removeFromSuperview];
        self.currentContentView = nil;
    }
}

#pragma mark - Move Cells

- (void)closeAccordionAnimated:(BOOL)aniamted {
    [self moveCellsBackToSelectedCell:self.currentCell animated:aniamted completion:nil];
    [self deselectRowAtIndexPath:[self indexPathForCell:self.currentCell] animated:aniamted];
    self.currentCell = nil;
}

- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    
    // Delegate
    [self.delegate accordionViewWillOpen:self];
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
        //
        BOOL found = NO;
        // Loop through the cells and move as needed
        for (UITableViewCell *visCell in self.visibleCells) {
            if (found) {
                visCell.frame = CGRectMake(visCell.frame.origin.x, visCell.frame.origin.y+distance, visCell.frame.size.width, visCell.frame.size.height);
            } else {
                if (visCell == cell) {
                    found = YES;
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
        [UIView animateWithDuration:0.3 animations:^{
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

- (void)moveCellsBackToSelectedCell:(UITableViewCell *)cell animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    animated = NO;
    // Delegate
    [self.delegate accordionViewWillClose:self];
    
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
//
        //
        BOOL found = NO;
        UITableViewCell *currentCell;
        // Loop through the cells and move as needed
        for (UITableViewCell *visCell in self.visibleCells) {
            if (found) {
                visCell.frame = CGRectMake(visCell.frame.origin.x, currentCell.frame.origin.y+currentCell.frame.size.height, visCell.frame.size.width, visCell.frame.size.height);
                currentCell = visCell;
            } else {
                if (visCell == cell) {
                    found = YES;
                    currentCell = cell;
                }
            }
        }

    };
    
    // Move the cells
    if (animated) {
        [self beginUpdates];
        [UIView animateWithDuration:0.3 animations:^{
            // Move the cells
            moveCells();
            // Adjust the content size
            self.contentSize = self.originContentSize;
        } completion:^(BOOL finished) {
            //
            [self endUpdates];
            self.accordionIsOpen = NO;
            if (completion) completion(finished);
            // Delegate
            [self.delegate accordionViewDidClose:self];
        }];
    } else {
        [self beginUpdates];
        moveCells();
        self.contentSize = self.originContentSize;
        [self endUpdates];
        self.accordionIsOpen = NO;
        if (completion) completion(YES);
        // Delegate
        [self.delegate accordionViewDidClose:self];
    }
    
}

#pragma mark - Table View Delegate Object

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
        [self moveCellsBackToSelectedCell:self.currentCell animated:YES completion:^(BOOL finished) {
            [self removeContentView];
            // Deselect the row
            [self deselectRowAtIndexPath:indexPath animated:NO];
            self.currentCell = nil;
        }];
        
    }
    
    // Set the last index path
    [self.removedIndexPaths setObject:indexPath forKey:[NSNumber numberWithInteger:indexPath.section]];
}

@end
