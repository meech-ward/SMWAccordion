//
//  SMWAccordionTableViewDataSourceObject.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

@import UIKit;

@class SMWAccordionTableView;

@protocol SMWAccordionTableViewDataSource <NSObject, UITableViewDataSource>

@optional

// Called before any accordion animations
- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end


@interface SMWAccordionTableViewDataSourceObject : NSObject <SMWAccordionTableViewDataSource>

@property (nonatomic, weak) id <SMWAccordionTableViewDataSource>dataSource;
@property (nonatomic, weak) SMWAccordionTableView *accordionView;

@end
