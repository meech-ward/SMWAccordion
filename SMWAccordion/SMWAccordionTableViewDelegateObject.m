//
//  SMWAccordionTableViewDelegateObject.m
//  SMWAccordion
//
//  Created by Sam Meech Ward on 2015-01-04.
//  Copyright (c) 2015 Sam Meech-Ward. All rights reserved.
//

#import "SMWAccordionTableViewDelegateObject.h"
#import "SMWAccordionTableView.h"

@implementation SMWAccordionTableViewDelegateObject

#pragma mark - Table View

#pragma mark Configuring Rows for the Table View

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:heightForRowAtIndexPath:)]) {
        return [self.delegate tableView:tableView heightForRowAtIndexPath:indexPath];
    }
    return [self.accordionView rowHeight];
}

//- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Optional
//}

//- (NSInteger)tableView:(UITableView *)tableView indentationLevelForRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Optional
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:willDisplayCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
    }
    [self.accordionView tableView:tableView willDisplayCell:cell forRowAtIndexPath:indexPath];
}

#pragma mark Tracking the Removal of Views

- (void)tableView:(UITableView *)tableView didEndDisplayingCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingCell:forRowAtIndexPath:)]) {
        [self.delegate tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
    }
    [self.accordionView tableView:tableView didEndDisplayingCell:cell forRowAtIndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didEndDisplayingHeaderView:(UIView *)view forSection:(NSInteger)section {
    if ([self.delegate respondsToSelector:@selector(tableView:didEndDisplayingFooterView:forSection:)]) {
        [self.delegate tableView:tableView didEndDisplayingHeaderView:view forSection:section];
    }
}
//
//- (void)tableView:(UITableView *)tableView didEndDisplayingFooterView:(UIView *)view forSection:(NSInteger)section {
//    // Optional
//}


#pragma mark Managing Selections

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Optional
//}


//- (BOOL)respondsToSelector:(SEL)aSelector {
////    if ([super respondsToSelector:aSelector]) {
////        return YES;
////    }
////    
////    if ([self.delegate respondsToSelector:aSelector]) {
////        [self.accordionView setRealDelegate:self.delegate];
////        [self performSelector:@selector(setSelfAsDelegate) withObject:nil afterDelay:0.0];
////        return YES;
//////        // Perform the selector
//////        [self.delegate performSelector:aSelector];
//////        ((void (*)(id, SEL))[(NSObject *)self.delegate methodForSelector:aSelector])(self.delegate, aSelector);
////    }
////    return NO;
//    return YES;
//}
////
////- (void)setSelfAsDelegate {
////    [self.accordionView setRealDelegate:self];
////}
//
////void dynamicMethodIMP(id self, SEL _cmd) {
////    // implementation ....
////}
////
////
//+ (BOOL) resolveInstanceMethod:(SEL)aSEL {
////{
////    if (aSEL == @selector(resolveThisMethodDynamically))
////    {
////        class_addMethod([self class], aSEL, (IMP) dynamicMethodIMP, "v@:");
////        return YES;
////    }
//    NSLog(@"RESolve instance method %@", aSEL);
//    return [super resolveInstanceMethod:aSEL];
//}


@end
