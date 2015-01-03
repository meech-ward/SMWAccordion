//
//  SMWAccordianTableView.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableView.h"

@interface SMWAccordionTableView()

@property (nonatomic) UIView *currentContentView;
@property (nonatomic) UITableViewCell *currentCell;
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
}

- (void)setup {
    self.shouldAnimate = YES;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
//    [super touchesBegan:touches withEvent:event];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
//    [self reloadData];
    // Get the current content view height
    float contentHeight = self.currentContentView ? self.currentContentView.bounds.size.height : 0;
    
    // Get the currently selected cell
    self.currentCell = [self cellForRowAtIndexPath:[self indexPathForSelectedRow]];
    if (![self.visibleCells containsObject:self.currentCell]) {
        self.accordionIsOpen = NO;
    }
    
    // Get the current location
    UITouch *touch = [[event allTouches] anyObject];
    CGPoint location = [touch locationInView:self];
    CGPoint selectedLocation = [touch locationInView:self.currentCell];
    
    //
    if (selectedLocation.y > self.currentCell.frame.size.height && self.accordionIsOpen) {
        if (selectedLocation.y < self.currentCell.frame.size.height+contentHeight) {
            return;
        }
        location = CGPointMake(location.x, location.y - contentHeight);
    }
    
    //
    [self deselectRowAtIndexPath:[self indexPathForSelectedRow] animated:NO];
    for (NSIndexPath *indexPath in self.indexPathsForVisibleRows) {
        [self deselectRowAtIndexPath:indexPath animated:NO];
    }
    
    // Get the index path from the location
    NSIndexPath *indexPath = [super indexPathForRowAtPoint:location];
    
    // Get cell for the index path
    UITableViewCell *nextCell = [self cellForRowAtIndexPath:indexPath];
    
    // Get the content view for the index path
    [self updateCurrentContentViewWithIndexPath:indexPath];
    contentHeight = self.currentContentView.bounds.size.height;
    
    // Show/Hide the content
    if (self.accordionIsOpen) {
//        [self beginUpdates];
        [self moveCellsBackToSelectedCell:self.currentCell animated:self.shouldAnimate completion:^(BOOL finished) {
            [self moveCellsFromSelectedCell:nextCell distance:contentHeight animated:self.shouldAnimate completion:^(BOOL finished) {
//                [self endUpdates];
            }];
        }];
    } else if (!self.accordionIsOpen) {
        [self moveCellsFromSelectedCell:nextCell distance:contentHeight animated:self.shouldAnimate completion:nil];
    }
    
    //
    // Modify the frame of the content view
    self.currentContentView.frame = CGRectMake(nextCell.frame.origin.x, nextCell.frame.origin.y+nextCell.frame.size.height, self.currentContentView.bounds.size.width, self.currentContentView.bounds.size.height);
    [self insertSubview:self.currentContentView atIndex:0];
    
    // Use the select row at index path function to show the current row instead of letting touches ended do it's default thing
//    [super touchesEnded:touches withEvent:event];
    [self selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
    //
    self.currentCell = nextCell;
}

- (void)updateCurrentContentViewWithIndexPath:(NSIndexPath *)indexPath {
    // Remove the old content view
    if (self.currentContentView) {
        [self.currentContentView removeFromSuperview];
    }
    
    // Get the new content view
    self.currentContentView = [self.delegate accordionView:self contentViewForRowAtIndexPath:indexPath];
    if (self.currentContentView) {
        
    }
}

#pragma mark - Move Cells

- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    
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
    
    // Move the cells
    animated ? [UIView animateWithDuration:0.3 animations:moveCells completion:^(BOOL finished) {
        //
        self.accordionIsOpen = YES;
        if (completion) completion(finished);
    }] : moveCells();
    
    
}

- (void)moveCellsBackToSelectedCell:(UITableViewCell *)cell animated:(BOOL)animated completion:(void(^)(BOOL finished))completion {
    // Create a block to move the cells
    void (^moveCells)(void) = ^{
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
    animated ? [UIView animateWithDuration:0.3 animations:moveCells completion:^(BOOL finished) {
        //
        self.accordionIsOpen = NO;
        if (completion) completion(finished);
    }] : moveCells();
    
}

@end
