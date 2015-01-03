//
//  SMWAccordianTableView.h
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-03.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SMWAccordionTableView;

@protocol SMWAccordionTableViewDelegate <NSObject, UIScrollViewDelegate, UITableViewDelegate>

@optional

// Called before any accordion animations
- (UIView *)accordionView:(SMWAccordionTableView *)accordionView contentViewForRowAtIndexPath:(NSIndexPath *)indexPath;

@end



@interface SMWAccordionTableView : UITableView

@property (nonatomic) BOOL shouldAnimate;

@property (nonatomic, assign) id<SMWAccordionTableViewDelegate>delegate;

@end


