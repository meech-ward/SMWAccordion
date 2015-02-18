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

@protocol SMWAccordionTableViewDelegate <NSObject, UIScrollViewDelegate, UITableViewDelegate>

@optional

- (void)accordionViewWillClose:(SMWAccordionTableView *)accordionView;
- (void)accordionViewDidClose:(SMWAccordionTableView *)accordionView;

- (void)accordionViewWillOpen:(SMWAccordionTableView *)accordionView;
- (void)accordionViewDidOpen:(SMWAccordionTableView *)accordionView;

@end

@interface SMWAccordionTableViewDelegateObject : NSObject <SMWAccordionTableViewDelegate>

@property (weak, nonatomic) id<SMWAccordionTableViewDelegate>delegate;
@property (weak, nonatomic) SMWAccordionTableView<UITableViewDelegate> *accordionView;

@end
