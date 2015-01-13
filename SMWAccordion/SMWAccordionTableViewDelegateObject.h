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

@end

@interface SMWAccordionTableViewDelegateObject : NSObject <SMWAccordionTableViewDelegate>

@property (nonatomic, weak) id<SMWAccordionTableViewDelegate>delegate;
@property (nonatomic, weak) SMWAccordionTableView *accordionView;

@end
