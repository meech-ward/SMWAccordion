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

//
// Data Source
//
@protocol SMWAccordionTableViewDataSource <NSObject, UITableViewDataSource>

// Called before any accordion animations
- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface SMWAccordionTableView : UITableView

// Should the accordion animate up and down to show the content view
@property (nonatomic) BOOL shouldAnimate;

// The current content view being show, nil if no cells are selected
@property (strong, nonatomic, readonly) UIView *currentContentView;

// Close the accordion
- (void)closeAccordionAnimated:(BOOL)aniamted;
- (void)deselectRowAtIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

//- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
//- (void)moveCellsBackToSelectedCell:(UITableViewCell *)cell animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

// Set the current table view delegate and datasource as accordion delegate and datasource
@property (nonatomic, assign) id <SMWAccordionTableViewDataSource>dataSource;
@property (nonatomic, assign) id <SMWAccordionTableViewDelegate>delegate;

@end


