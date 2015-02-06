//
//  SMWAccordionTableViewDelegateObject.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
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
@property (weak, nonatomic) SMWAccordionTableView *accordionView;

@end
