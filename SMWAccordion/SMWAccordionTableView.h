//
//  SMWAccordianTableView.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

@import UIKit;

#import "SMWAccordionTableViewDelegateObject.h"
#import "SMWAccordionTableViewDataSourceObject.h"

@interface SMWAccordionTableView : UITableView

@property (nonatomic) BOOL shouldAnimate;

//
@property (strong, nonatomic) UIView *currentContentView;

//
- (void)closeAccordionAnimated:(BOOL)aniamted;
- (void)moveCellsFromSelectedCell:(UITableViewCell *)cell distance:(float)distance animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;
- (void)moveCellsBackToSelectedCell:(UITableViewCell *)cell animated:(BOOL)animated completion:(void(^)(BOOL finished))completion;

//
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;
- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath;

//
@property (nonatomic, assign) id <SMWAccordionTableViewDataSource>dataSource;
@property (nonatomic, assign) id <SMWAccordionTableViewDelegate>delegate;

//
- (void)setRealDelegate:(id)delegate;

@end


